#!/bin/sh

export DB_PASS=$(cat /run/secrets/mariadb_db_password 2>/dev/null || true)
export DB_ROOT=$(cat /run/secrets/mariadb_db_root_password 2>/dev/null || true)

sh /usr/local/bin/create_db.sh

exec /usr/bin/mysqld --skip-log-error
