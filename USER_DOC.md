# USER_DOC.md

## Overview
This stack provides a secure WordPress site with NGINX (TLS), MariaDB, and persistent storage, all managed via Docker Compose.

## Services Provided
- NGINX (entrypoint, HTTPS only)
- WordPress (php-fpm)
- MariaDB (database)

## How to Start and Stop
- To start: `make` or `docker-compose -f srcs/docker-compose.yml up -d --build`
- To stop: `make down` or `docker-compose -f srcs/docker-compose.yml down`

## Accessing the Website
- Open `https://saslanya.42.fr` in your browser (replace with your domain if needed).
- WordPress admin panel: `https://saslanya.42.fr/wp-admin`

## Credentials
- All credentials are stored in the `secrets/` folder (not in git).
- Admin and user passwords: see `secrets/credentials.txt`.
- Database passwords: see `secrets/db_password.txt` and `secrets/db_root_password.txt`.

## Checking Service Status
- Use `docker ps` to see running containers.
- Use `docker logs <container>` to view logs (e.g., `docker logs nginx`).

## Data Persistence
- WordPress files: `/home/<login>/data/wordpress` on host
- Database files: `/home/<login>/data/mariadb` on host

## Troubleshooting
- If a service fails, check logs and ensure secrets/ files exist.
- For certificate issues, check `/etc/nginx/ssl/` inside the nginx container.
