#!/bin/sh

export ADMIN_PASS=$(cat /run/secrets/wordpress_superpass 2>/dev/null || true)
export SIMPLE_PASS=$(cat /run/secrets/wordpress_simplepass 2>/dev/null || true)
export DB_PASS=$(cat /secrets/mariadb/db_password.txt)

set -e

sh /usr/local/bin/wp-config-create.sh

sh /usr/local/bin/wp-init-users.sh

exec /usr/sbin/php-fpm8 -F
