*This project has been created as part of the 42 curriculum by saslanya

# Description
A simple infrastructure project for 42 school using Docker Compose. It includes NGINX (with TLS), WordPress (php-fpm), and MariaDB, each in its own container. The goal is to automate deployment and show how services interact securely.

# Instructions
1. Clone the repository.
2. Edit `.env` with your settings.
3. Run `make` or `docker-compose -f srcs/docker-compose.yml up --build -d`.
4. Open `https://saslanya.42.fr` in your browser.

# Resources
- [Docker Docs](https://docs.docker.com/)
- [NGINX Docs](https://nginx.org/en/docs/)
- [WordPress Docs](https://wordpress.org/support/)
- [MariaDB Docs](https://mariadb.com/kb/en/documentation/)
- AI was used for: help with code generation, automation, and documentation.

# Project Description
Docker is used to isolate and automate services. All configs and sources are in `srcs/requirements`. Environment variables and secrets manage configuration and security.

## Design Choices
- **Virtual Machines vs Docker:** Docker is lighter and faster than VMs.
- **Secrets vs Environment Variables:**
	- Docker secrets are stored in an encoded form and are available inside containers as regular files, which increases security.
	- Environment variables are only available while the container is running; if you need them during build, use args.
- **Docker Network vs Host Network:** 
    - Docker network isolates containers, so each service only sees others in its own namespace. This matches Docker's philosophy of process isolation and security.
    - Host network is not used, so containers do not have direct access to the host's network stack, which improves security and separation.
- **Docker Volumes vs Bind Mounts:**
    - Docker volumes are managed by Docker and referenced by a name in docker-compose. The actual location on the host is abstracted unless you specify it manually (with device: config). Volumes are portable and easy to back up.
    - Bind mounts directly link a specific folder on the host to a folder inside the container (you specify both paths). This is a more direct and “raw” connection.
    - In both cases, the real data is stored on the host, but with volumes you reference by name (and Docker manages the location), while with bind mounts you reference by explicit host path.