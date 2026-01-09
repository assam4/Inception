NAME := inception
ENV := srcs/.env
SSL_CERTS := srcs/requirements/nginx/tools/*.key srcs/requirements/nginx/tools/*.crt
DIRS := ~/data/mariadb/  ~/data/wordpress ~/data/redis

all:
	@mkdir -p ${DIRS}
	@docker compose -f ./srcs/docker-compose.yml --env-file ${ENV} up -d | grep -E "Building|Build|Created|Starting|Started|Running" || true
build:
	@mkdir -p ${DIRS}
	@docker compose -f ./srcs/docker-compose.yml --env-file ${ENV} build --no-cache | grep -E "Building|Build|Recreated|Created" || true
up:
	@docker compose -f ./srcs/docker-compose.yml --env-file ${ENV} up -d | grep -E "Starting|Started|Running" || true

down:
	@docker compose -f ./srcs/docker-compose.yml --env-file ${ENV} down | grep -E "Stopping|Stopped" || true
clean: down
	sudo rm -rf ~/data
	@echo "Cleaning volumes"
fclean: clean 
	@rm -f ${SSL_CERTS}
	@echo "Cleaning ssl_certificate"
	@docker system prune --all --force --volumes | grep -E "Removing|Removed|password" || true
re: fclean all

.PHONY	: all build up  down re clean fclean
