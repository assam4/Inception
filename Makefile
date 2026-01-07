NAME = inception
ENV = srcs/.env

all:
	mkdir -p ~/data/mariadb/  ~/data/wordpress
	docker compose -f ./srcs/docker-compose.yml --env-file ${ENV} up -d
build:
	mkdir -p ~/data/mariadb/  ~/data/wordpress
	docker compose -f ./srcs/docker-compose.yml --env-file ${ENV} up -d --build

down:
	docker compose -f ./srcs/docker-compose.yml --env-file ${ENV} down

re: fclean all

clean: down
	sudo rm -rf ~/data
#	rm -f srcs/requirements/nginx/tools/*.crt srcs/requirements/nginx/tools/*.key

fclean: clean 
	docker system prune --all --force --volumes

.PHONY	: all build down re clean fclean
