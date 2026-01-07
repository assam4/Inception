#!/bin/sh

export ADMIN_PASS=$(cat /run/secrets/wordpress_superpass 2>/dev/null || true)
export SIMPLE_PASS=$(cat /run/secrets/wordpress_simplepass 2>/dev/null || true)
export DB_PASS=$(cat /run/secrets/mariadb_db_password 2>/dev/null || true)

set -e

sh /usr/local/bin/wp-config-create.sh
sh /usr/local/bin/wp-init-users.sh

wp plugin install redis-cache --activate --allow-root
wp redis enable --allow-root

exec /usr/sbin/php-fpm8 -F
