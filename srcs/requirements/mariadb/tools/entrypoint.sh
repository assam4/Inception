#!/bin/sh

if [ -f /create_db.sh ]; then
    sh /create_db.sh
else
    echo "Error: /create_db.sh not found!"
    exit 1
fi

exec /usr/bin/mysqld --skip-log-error
