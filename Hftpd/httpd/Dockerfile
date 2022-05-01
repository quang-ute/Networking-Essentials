FROM alpine:3.15
RUN apk --no-cache add thttpd

RUN adduser -D static
WORKDIR /home/static
COPY --chown=static:static . .
RUN chmod -R 644 index.html index_get.html index_post.html
USER static

CMD ["thttpd", "-D", "-h", "0.0.0.0", "-p", "3000", "-d", "/home/static", "-u", "static", "-l", "-", "-M", "60"]
