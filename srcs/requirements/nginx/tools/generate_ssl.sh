#!/bin/sh
set -e

CERT_DIR="/etc/nginx/ssl"
DOMAIN="saslanya.42.fr"
DOMAIN="${DOMAIN_NAME:-saslanya.42.fr}"
CRT_FILE="$CERT_DIR/$DOMAIN.crt"
KEY_FILE="$CERT_DIR/$DOMAIN.key"

mkdir -p "$CERT_DIR"

if [ ! -f "$CRT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
    echo "Generating self-signed SSL certificate..."
    openssl req -x509 -nodes -days 365 \
        -subj "/C=RU/ST=42/L=School/O=Inception/CN=$DOMAIN" \
        -newkey rsa:2048 \
        -keyout "$KEY_FILE" \
        -out "$CRT_FILE"
else
    echo "SSL certificate already exists. Skipping generation."
fi

exec "$@"
