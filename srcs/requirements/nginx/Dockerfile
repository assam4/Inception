FROM alpine:3.16

RUN apk update && \
    apk upgrade && \
    apk add --no-cache nginx openssl

COPY tools/generate_ssl.sh /usr/local/bin/generate_ssl.sh
COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod +x /usr/local/bin/generate_ssl.sh

EXPOSE 80 443

CMD ["/usr/local/bin/generate_ssl.sh", "nginx", "-g", "daemon off;"]
