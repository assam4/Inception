#!/bin/sh

WP_PATH="${WP_PATH:-/var/www}"
SITE_URL="${SITE_URL}"
SITE_TITLE="${SITE_TITLE}"
ADMIN_USER="${ADMIN_USER}"
ADMIN_PASS="${ADMIN_PASS}"
ADMIN_EMAIL="${ADMIN_EMAIL}"
SIMPLE_USER="${SIMPLE_USER}"
SIMPLE_PASS="${SIMPLE_PASS}"
SIMPLE_EMAIL="${SIMPLE_EMAIL}"

if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "wp-config.php не найден, установка невозможна."
    exit 1
fi

wp core install --url="$SITE_URL" --title="$SITE_TITLE" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASS" --admin_email="$ADMIN_EMAIL" --skip-email --path=$WP_PATH
    
# Создание обычного пользователя, если его нет
if ! wp user get "$SIMPLE_USER" --path=$WP_PATH > /dev/null 2>&1; then
    wp user create "$SIMPLE_USER" "$SIMPLE_EMAIL" --role=author --user_pass="$SIMPLE_PASS" --path=$WP_PATH
fi

# Запуск php-fpm
php-fpm8 -F
