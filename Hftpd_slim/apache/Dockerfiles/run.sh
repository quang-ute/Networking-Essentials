#!/bin/bash
#
# Version: 1.2
# Purpose:
#   - Creating required directories
#   - Creating error pages
#   - Creating public directory
#   - Creating default index.html
#   - Setting server name
#   - Setting server e-mail
#   - Setting web root
#   - Setting user and group
#   - Setting SSL/TLS Certificate
#   - Setting php.ini file
#   - Starting Apache damon
#

ERROR=/error
HTDOCS=/htdocs
APACHE_ROOT=/etc/apache2/
SERVER_ROOT=/var/www/localhost
TEMPLATE_ROOT=/var/www/skel
PHP_INI=/etc/php7/php.ini

#
# Checks if required folder exists. If not, it will be created.
#
function create_directories {
    if [[ ! -z ${APACHE_WEB_ROOT} ]]; then
        if [[ ${APACHE_WEB_ROOT} =~ ^/ ]]; then
            HTDOCS=${APACHE_WEB_ROOT}
        else
            HTDOCS=/${APACHE_WEB_ROOT}
        fi
    fi

    DIRECTORIES=(/cgi-bin ${HTDOCS} /logs ${ERROR})

    for DIRECTORY in ${DIRECTORIES[@]}; do
        DIRECTORY_PATH="${SERVER_ROOT}${DIRECTORY}"
        if [[ ! -d ${DIRECTORY_PATH} ]]; then
            mkdir -p ${DIRECTORY_PATH}
            echo "Created directory ${DIRECTORY}"
        fi
    done
}

#
# Check if error folder is empty. If not, it will create error pages.
#
function create_error_pages {
    if [[ ! "$(ls -A "${SERVER_ROOT}${ERROR}")" ]]; then
        cp -r ${TEMPLATE_ROOT}${ERROR} ${SERVER_ROOT}
        echo "Created error pages.";
    fi
}

function create_public_directory {
    if [[ ! -z ${PUBLIC_DIRECTORY} ]]; then
        PUBLIC_DIRECTORY_PATH=${SERVER_ROOT}${HTDOCS}/${PUBLIC_DIRECTORY}
        sed -i "s/\"\/var\/www\/localhost\/htdocs\"/\"\/var\/www\/localhost\/htdocs\/${PUBLIC_DIRECTORY}\"/" ${APACHE_ROOT}/httpd.conf
        sed -i "s/\"\/var\/www\/localhost\/htdocs\"/\"\/var\/www\/localhost\/htdocs\/${PUBLIC_DIRECTORY}\"/" ${APACHE_ROOT}/conf.d/ssl.conf

        if [[ ! -d ${PUBLIC_DIRECTORY_PATH} ]]; then
            mkdir ${PUBLIC_DIRECTORY_PATH}
            echo "Created public directory."
        fi
    fi
}

function create_default_page {
    if [[ -z ${PUBLIC_DIRECTORY} ]] && [[ -z "$(ls -A ${SERVER_ROOT}${HTDOCS})" ]]; then
        cp ${TEMPLATE_ROOT}/htdocs/index.php ${SERVER_ROOT}${HTDOCS}/index.php
        cp ${TEMPLATE_ROOT}/htdocs/info.php ${SERVER_ROOT}${HTDOCS}/info.php
        echo "Created default pages."
    elif [[ ! -z ${PUBLIC_DIRECTORY} ]] && [[ -z "$(ls -A ${SERVER_ROOT}${HTDOCS}/${PUBLIC_DIRECTORY})" ]]; then
        cp ${TEMPLATE_ROOT}/htdocs/index.php ${SERVER_ROOT}${HTDOCS}/${PUBLIC_DIRECTORY}/index.php
        cp ${TEMPLATE_ROOT}/htdocs/info.php ${SERVER_ROOT}${HTDOCS}/${PUBLIC_DIRECTORY}/info.php
        echo "Created default pages."
    fi
}

function set_server_name {
    if [[ ! -z ${APACHE_SERVER_NAME} ]]; then
        sed -i "s/ServerName www.example.com:80/ServerName ${APACHE_SERVER_NAME}:80/" ${APACHE_ROOT}/httpd.conf
        sed -i "s/ServerName www.example.com:443/ServerName ${APACHE_SERVER_NAME}:443/" ${APACHE_ROOT}/conf.d/ssl.conf

        sed -i "s/error\.log/error\.${APACHE_SERVER_NAME}\.log/" ${APACHE_ROOT}/httpd.conf
        sed -i "s/access\.log/access\.${APACHE_SERVER_NAME}\.log/" ${APACHE_ROOT}/httpd.conf
        echo "Set server name to ${APACHE_SERVER_NAME}."
    fi
}

function set_server_mail {
    if [[ ! -z ${APACHE_SERVER_MAIL} ]]; then
        sed -i "s/ServerAdmin .*/ServerAdmin ${APACHE_SERVER_MAIL}/" ${APACHE_ROOT}/httpd.conf
        sed -i "s/ServerAdmin .*/ServerAdmin ${APACHE_SERVER_MAIL}/" ${APACHE_ROOT}/conf.d/ssl.conf
        echo "Set server email to ${APACHE_SERVER_MAIL}."
    elif [[ ! -z ${APACHE_SERVER_NAME} ]]; then
        sed -i "s/ServerAdmin .*/ServerAdmin webmaster@${APACHE_SERVER_NAME}/" ${APACHE_ROOT}/httpd.conf
        sed -i "s/ServerAdmin .*/ServerAdmin webmaster@${APACHE_SERVER_NAME}/" ${APACHE_ROOT}/conf.d/ssl.conf
        echo "Set server email to webmaster@${APACHE_SERVER_NAME}."
    fi
}

function set_web_root {
    local HTDOCS_TMP=${HTDOCS}

    if [[ ${APACHE_WEB_ROOT} =~ ^/ ]]; then
        HTDOCS_TMP=${APACHE_WEB_ROOT:1:${#APACHE_WEB_ROOT}}
    fi

    if [[ ${HTDOCS_TMP} == *"/"* ]]; then
        HTDOCS_TMP=${HTDOCS_TMP//\//\\/}
    fi

    sed -i "s/\/var\/www\/localhost\/htdocs/\/var\/www\/localhost${HTDOCS_TMP}/" ${APACHE_ROOT}/httpd.conf
    sed -i "s/\/var\/www\/localhost\/htdocs/\/var\/www\/localhost${HTDOCS_TMP}/" ${APACHE_ROOT}/conf.d/ssl.conf

    echo "Set web root to ${HTDOCS}."
}

function set_user_and_group {
    if [[ ! -z ${APACHE_RUN_USER} ]]; then

        if [[ -z ${APACHE_RUN_GROUP} ]]; then
            APACHE_RUN_GROUP=apache
        fi

        sed -i "s/User apache/User ${APACHE_RUN_USER}/" ${APACHE_ROOT}/httpd.conf
        sed -i "s/Group apache/Group ${APACHE_RUN_GROUP}/" ${APACHE_ROOT}/httpd.conf

        if [[ ! -z ${APACHE_RUN_USER_ID} ]] && [[ ! -z ${APACHE_RUN_GROUP_ID} ]]; then
            addgroup -g ${APACHE_RUN_GROUP_ID} ${APACHE_RUN_GROUP} > /dev/null 2>&1
            adduser -u ${APACHE_RUN_USER_ID} -G ${APACHE_RUN_GROUP} -h ${SERVER_ROOT} ${APACHE_RUN_USER} > /dev/null 2>&1
        else
            addgroup ${APACHE_RUN_GROUP} > /dev/null 2>&1
            adduser -G ${APACHE_RUN_GROUP} -h ${SERVER_ROOT} ${APACHE_RUN_USER} > /dev/null 2>&1
        fi

        echo "Set apache custom user and group."
    else
        APACHE_RUN_USER=apache
        APACHE_RUN_GROUP=apache
        echo "Set apache default user and group."
    fi

    chown -R ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} ${SERVER_ROOT}${HTDOCS}
}

function set_ssl {
    if [[ -n ${APACHE_SSL_CERTIFICATE} && -n ${APACHE_SSL_CERTIFICATE_KEY} && -n ${APACHE_SSL_CERTIFICATE_CHAIN} ]] ; then
        sed -i -e "s/SSLCertificateChainFile .*/SSLCertificateChainFile ${APACHE_SSL_CERTIFICATE_CHAIN//\//\\/}/" -e "s/#SSLCertificateChainFile/SSLCertificateChainFile/" ${APACHE_ROOT}/conf.d/ssl.conf
        echo "Set SSLCertificateChainFile to ${APACHE_SSL_CERTIFICATE_CHAIN}"
    fi

    if [[ -n ${APACHE_SSL_CERTIFICATE} && -n ${APACHE_SSL_CERTIFICATE_KEY} ]] ; then
        sed -i -e "s/SSLCertificateFile .*/SSLCertificateFile ${APACHE_SSL_CERTIFICATE//\//\\/}/" -e "s/#SSLCertificateFile/SSLCertificateFile/" ${APACHE_ROOT}/conf.d/ssl.conf
        sed -i -e "s/SSLCertificateKeyFile .*/SSLCertificateKeyFile ${APACHE_SSL_CERTIFICATE_KEY//\//\\/}/" -e "s/#SSLCertificateKeyFile/SSLCertificateKeyFile/" ${APACHE_ROOT}/conf.d/ssl.conf
        echo "Set SSLCertificateFile to ${APACHE_SSL_CERTIFICATE}"
        echo "Set SSLCertificateKeyFile to ${APACHE_SSL_CERTIFICATE_KEY}"
    fi
}

function set_php_ini {
    if [[ ! -z "$PHP_SHORT_OPEN_TAG" ]]; then sed -i "s/\;\?\\s\?short_open_tag = .*/short_open_tag = $PHP_SHORT_OPEN_TAG/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_OUTPUT_BUFFERING" ]]; then sed -i "s/\;\?\\s\?output_buffering = .*/output_buffering = $PHP_OUTPUT_BUFFERING/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_OPEN_BASEDIR" ]]; then sed -i "s/\;\?\\s\?open_basedir = .*/open_basedir = $PHP_OPEN_BASEDIR/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_MAX_EXECUTION_TIME" ]]; then sed -i "s/\;\?\\s\?max_execution_time = .*/max_execution_time = $PHP_MAX_EXECUTION_TIME/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_MAX_INPUT_TIME" ]]; then sed -i "s/\;\?\\s\?max_input_time = .*/max_input_time = $PHP_MAX_INPUT_TIME/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_MAX_INPUT_VARS" ]]; then sed -i "s/\;\?\\s\?max_input_vars = .*/max_input_vars = $PHP_MAX_INPUT_VARS/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_MEMORY_LIMIT" ]]; then sed -i "s/\;\?\\s\?memory_limit = .*/memory_limit = $PHP_MEMORY_LIMIT/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_ERROR_REPORTING" ]]; then sed -i "s/\;\?\\s\?error_reporting = .*/error_reporting = $PHP_ERROR_REPORTING/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_DISPLAY_ERRORS" ]]; then sed -i "s/\;\?\\s\?display_errors = .*/display_errors = $PHP_DISPLAY_ERRORS/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_DISPLAY_STARTUP_ERRORS" ]]; then sed -i "s/\;\?\\s\?display_startup_errors = .*/display_startup_errors = $PHP_DISPLAY_STARTUP_ERRORS/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_LOG_ERRORS" ]]; then sed -i "s/\;\?\\s\?log_errors = .*/log_errors = $PHP_LOG_ERRORS/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_LOG_ERRORS_MAX_LEN" ]]; then sed -i "s/\;\?\\s\?log_errors_max_len = .*/log_errors_max_len = $PHP_LOG_ERRORS_MAX_LEN/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_IGNORE_REPEATED_ERRORS" ]]; then sed -i "s/\;\?\\s\?ignore_repeated_errors = .*/ignore_repeated_errors = $PHP_IGNORE_REPEATED_ERRORS/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_REPORT_MEMLEAKS" ]]; then sed -i "s/\;\?\\s\?report_memleaks = .*/report_memleaks = $PHP_REPORT_MEMLEAKS/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_HTML_ERRORS" ]]; then sed -i "s/\;\?\\s\?html_errors = .*/html_errors = $PHP_HTML_ERRORS/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_ERROR_LOG" ]]; then sed -i "s/\;\?\\s\?error_log = .*/error_log = $PHP_ERROR_LOG/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_POST_MAX_SIZE" ]]; then sed -i "s/\;\?\\s\?post_max_size = .*/post_max_size = $PHP_POST_MAX_SIZE/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_DEFAULT_MIMETYPE" ]]; then sed -i "s/\;\?\\s\?default_mimetype = .*/default_mimetype = $PHP_DEFAULT_MIMETYPE/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_DEFAULT_CHARSET" ]]; then sed -i "s/\;\?\\s\?default_charset = .*/default_charset = $PHP_DEFAULT_CHARSET/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_FILE_UPLOADS" ]]; then sed -i "s/\;\?\\s\?file_uploads = .*/file_uploads = $PHP_FILE_UPLOADS/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_UPLOAD_TMP_DIR" ]]; then sed -i "s/\;\?\\s\?upload_tmp_dir = .*/upload_tmp_dir = $PHP_UPLOAD_TMP_DIR/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_UPLOAD_MAX_FILESIZE" ]]; then sed -i "s/\;\?\\s\?upload_max_filesize = .*/upload_max_filesize = $PHP_UPLOAD_MAX_FILESIZE/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_MAX_FILE_UPLOADS" ]]; then sed -i "s/\;\?\\s\?max_file_uploads = .*/max_file_uploads = $PHP_MAX_FILE_UPLOADS/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_ALLOW_URL_FOPEN" ]]; then sed -i "s/\;\?\\s\?allow_url_fopen = .*/allow_url_fopen = $PHP_ALLOW_URL_FOPEN/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_ALLOW_URL_INCLUDE" ]]; then sed -i "s/\;\?\\s\?allow_url_include = .*/allow_url_include = $PHP_ALLOW_URL_INCLUDE/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_DEFAULT_SOCKET_TIMEOUT" ]]; then sed -i "s/\;\?\\s\?default_socket_timeout = .*/default_socket_timeout = $PHP_DEFAULT_SOCKET_TIMEOUT/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_DATE_TIMEZONE" ]]; then sed -i "s/\;\?\\s\?date.timezone = .*/date.timezone = $PHP_DATE_TIMEZONE/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_PDO_MYSQL_CACHE_SIZE" ]]; then sed -i "s/\;\?\\s\?pdo_mysql.cache_size = .*/pdo_mysql.cache_size = $PHP_PDO_MYSQL_CACHE_SIZE/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_PDO_MYSQL_DEFAULT_SOCKET" ]]; then sed -i "s/\;\?\\s\?pdo_mysql.default_socket = .*/pdo_mysql.default_socket = $PHP_PDO_MYSQL_DEFAULT_SOCKET/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_SESSION_SAVE_HANDLER" ]]; then sed -i "s/\;\?\\s\?session.save_handler = .*/session.save_handler = $PHP_SESSION_SAVE_HANDLER/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_SESSION_SAVE_PATH" ]]; then sed -i "s/\;\?\\s\?session.save_path = .*/session.save_path = $PHP_SESSION_SAVE_PATH/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_SESSION_USE_STRICT_MODE" ]]; then sed -i "s/\;\?\\s\?session.use_strict_mode = .*/session.use_strict_mode = $PHP_SESSION_USE_STRICT_MODE/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_SESSION_USE_COOKIES" ]]; then sed -i "s/\;\?\\s\?session.use_cookies = .*/session.use_cookies = $PHP_SESSION_USE_COOKIES/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_SESSION_COOKIE_SECURE" ]]; then sed -i "s/\;\?\\s\?session.cookie_secure = .*/session.cookie_secure = $PHP_SESSION_COOKIE_SECURE/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_SESSION_NAME" ]]; then sed -i "s/\;\?\\s\?session.name = .*/session.name = $PHP_SESSION_NAME/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_SESSION_COOKIE_LIFETIME" ]]; then sed -i "s/\;\?\\s\?session.cookie_lifetime = .*/session.cookie_lifetime = $PHP_SESSION_COOKIE_LIFETIME/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_SESSION_COOKIE_PATH" ]]; then sed -i "s/\;\?\\s\?session.cookie_path = .*/session.cookie_path = $PHP_SESSION_COOKIE_PATH/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_SESSION_COOKIE_DOMAIN" ]]; then sed -i "s/\;\?\\s\?session.cookie_domain = .*/session.cookie_domain = $PHP_SESSION_COOKIE_DOMAIN/" ${PHP_INI}; fi
    if [[ ! -z "$PHP_SESSION_COOKIE_HTTPONLY" ]]; then sed -i "s/\;\?\\s\?session.cookie_httponly = .*/session.cookie_httponly = $PHP_SESSION_COOKIE_HTTPONLY/" ${PHP_INI}; fi
}

#
# Make sure we're not confused by old, incompletely-shutdown httpd context after restarting the container.
# httpd won't start correctly if it thinks it is already running.
#
function clean {
    rm -rf /run/apache2/*
    echo "Cleanup of old Apache daemon."
}

#
# Starting Apache daemon...
#
function run {
    echo "Started Apache daemon."
    exec /usr/sbin/httpd -D FOREGROUND
}

function main {
    create_directories
    create_error_pages
    create_public_directory
    create_default_page

    set_server_name
    set_server_mail
    set_web_root
    set_user_and_group
    set_ssl

    set_php_ini

    clean
    run
}

main
