FROM php:8.1-alpine

RUN apk add --no-cache \
    mysql-client wget \
    && docker-php-ext-install mysqli pdo pdo_mysql

WORKDIR /app

RUN wget https://www.adminer.org/latest-en.php -O index.php

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080"]