.DEFAULT_GOAL := up

LABEL = jekyll_docker_epsi_bordeaux

CONTAINER_NAME = jekyll_epsi_bordeaux

DOCKER_EXEC = docker exec
DOCKER_COMPOSE = docker-compose

containers := $$(docker ps -af label=$(LABEL) -q)
images     := $$(docker images -af label=$(LABEL) -q)

build:
	$(DOCKER_COMPOSE) build

up: build
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down

restart:
	$(DOCKER_COMPOSE) restart

test:
	$(DOCKER_EXEC) $(CONTAINER_NAME) bundle exec rake test

help:
	$(DOCKER_EXEC) $(CONTAINER_NAME) jekyll help

draft:
	$(DOCKER_EXEC) $(CONTAINER_NAME) jekyll draft $(name)

clean: down
	docker stop $(containers) || true
	docker rm -f $(containers) || true
	docker rmi -f $(images) || true
	rm -rf _site .jekyll-metadata .sass-cache .git-metadata .bundle vendor

publish: 
	$(DOCKER_EXEC) $(CONTAINER_NAME) jekyll publish $(name)

logs:
	docker logs $(CONTAINER_NAME) -f 
