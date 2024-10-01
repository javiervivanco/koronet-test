DOCKER_COMPOSE := $(shell command -v docker-compose > /dev/null && echo docker-compose || echo "docker compose")
DOCKER_BUILDER_IMAGE := python:3.9-alpine
shell:
	docker run -it --rm --entrypoint sh -w /data  -v ${PWD}/webserver:/data ${DOCKER_BUILDER_IMAGE}

build:
	${DOCKER_COMPOSE} build
	docker images koronet-test
start: build
	${DOCKER_COMPOSE} up
