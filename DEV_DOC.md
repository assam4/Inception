# DEV_DOC.md

## Environment Setup
- Prerequisites: Docker, Docker Compose, GNU Make
- Clone the repo and create the `secrets/` folder with required files (see README.md)
- Edit `srcs/.env` for non-secret config (domain, usernames, etc.)

## Build and Launch
- `make` — build and start all services
- `make down` — stop all services
- `make clean` — stop and remove containers, clean data/volumes

## Managing Containers and Volumes
- `docker ps` — list running containers
- `docker-compose -f srcs/docker-compose.yml up -d --build` — manual build/run
- Data persists in `/home/<login>/data/wordpress` and `/home/<login>/data/mariadb`

## Secrets Management
- All passwords and sensitive data are in `secrets/` (not in git)
- Example files: `db_password.txt`, `db_root_password.txt`, `credentials.txt`
- Update secrets as needed and restart containers

## Project Data
- WordPress site files: `/home/<login>/data/wordpress`
- MariaDB data: `/home/<login>/data/mariadb`

## Useful Commands
- `docker logs <container>` — view logs
- `docker exec -it <container> sh` — shell inside container
- `docker-compose -f srcs/docker-compose.yml down -v` — remove containers and volumes

## Notes
- All Dockerfiles are custom, no images are pulled except Alpine base
- No passwords or secrets in git or Dockerfiles
- For any config changes, rebuild the affected service
