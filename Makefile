NAME = inception
ENV = srcs/.env

all:
	bash srcs/requirements/wordpress/tools/make_dir.sh
	docker-compose -f ./srcs/docker-compose.yml --env-file ${ENV} up -d
build:
	bash srcs/requirements/wordpress/tools/make_dir.sh
	docker-compose -f ./srcs/docker-compose.yml --env-file ${ENV} up -d --build

down:
	docker-compose -f ./srcs/docker-compose.yml --env-file ${ENV} down

re: clean all

clean: down
	docker system prune -a
	sudo rm -rf ~/data
	rm -f srcs/requirements/nginx/tools/*.crt srcs/requirements/nginx/tools/*.key

fclean: clean 
	docker system prune --all --force --volumes
	docker network prune --force
	docker volume prune --force

.PHONY	: all build down re clean fclean
