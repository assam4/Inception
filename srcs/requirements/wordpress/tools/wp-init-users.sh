#!/bin/sh

WP_PATH="${WP_PATH:-/var/www}"

if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "wp-config.php not found!."
    exit 1
fi

wp core install --url="$SITE_URL" --title="$SITE_TITLE" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASS" --admin_email="$ADMIN_EMAIL" --skip-email --path=$WP_PATH

wp option update comment_moderation 1 --path=$WP_PATH
wp option update comment_whitelist 0 --path=$WP_PATH
wp option update comment_previously_approved 1 --path=$WP_PATH
wp option update comments_notify 0 --path=$WP_PATH
wp option update duplicate_comment_window 300 --path=$WP_PATH

if ! wp user get "$SIMPLE_USER" --path=$WP_PATH > /dev/null 2>&1; then
    wp user create "$SIMPLE_USER" "$SIMPLE_EMAIL" --role=subscriber --user_pass="$SIMPLE_PASS" --path=$WP_PATH
fi
