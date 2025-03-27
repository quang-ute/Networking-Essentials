FROM python:3.9-slim

# Install Apache, libpcap, and other dependencies
RUN apt-get update && apt-get install -y \
    apache2 \
    libpcap-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Scapy
RUN pip install scapy

# Copy HTML files to Apache document root
COPY ./html/ /var/www/html/

# Copy sniffer script
COPY sniffer.py /app/sniffer.py

# Configure Apache to listen on port 5050
RUN sed -i 's/Listen 80/Listen 5050/' /etc/apache2/ports.conf
RUN sed -i 's/<VirtualHost \*:80>/<VirtualHost *:5050>/' /etc/apache2/sites-available/000-default.conf

# Expose port 5050
EXPOSE 5050

# Set working directory
WORKDIR /app

# Use entrypoint script to start services
CMD ["/bin/sh"]
