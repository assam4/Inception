FROM alpine:3.16

RUN apk update && apk add --no-cache redis

COPY conf/redis.conf /usr/local/etc/redis/redis.conf

CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]