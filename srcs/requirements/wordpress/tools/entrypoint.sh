#!/bin/sh

export ADMIN_PASS=$(awk -F: '/^superuser:/ {print $2}' /run/secrets/credentials 2>/dev/null || true)
export SIMPLE_PASS=$(awk -F: '/^simpleuser:/ {print $2}' /run/secrets/credentials 2>/dev/null || true)

set -e

sh /usr/local/bin/wp-config-create.sh

sh /usr/local/bin/wp-init-users.sh

exec /usr/sbin/php-fpm8 -F
