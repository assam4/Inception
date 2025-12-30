#!/bin/sh

set -e

sh /usr/local/bin/wp-config-create.sh

sh /usr/local/bin/wp-init-users.sh

exec /usr/sbin/php-fpm8 -F
