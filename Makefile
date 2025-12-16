include .env

INVENTORIES_DIR = ./inventory
PLAYBOOKS_DIR = ./playbook
RULE_WITH_ARGS = play play-dry-run

TEST_DIR = ./tests
TEST_PYTHON_FILE = $(TEST_DIR)/docker-compose.py
TEST_COMPOSE_FILE = $(TEST_DIR)/docker-compose.yml
TEST_SERVICE_DOCKER_FILE = $(TEST_DIR)/debian/service.yml
TEST_ANSIBLE_COMPOSE_FILE = $(TEST_DIR)/ansible/docker-compose.yml

ifeq ($(filter $(RULE_WITH_ARGS), $(firstword $(MAKECMDGOALS))),$(firstword $(MAKECMDGOALS)))
  RUN_ARGS = $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif

cli:
	@docker build -f ./docker/ansible/Dockerfile -t ansible .
	@docker run -it --rm --name ansible \
		--dns-search $(DNS_DOMAIN) \
		-v ./tests:/app/tests \
		-v ./:/app:ro \
		-v ~/.ssh:/home/ansible/.ansible_keys:ro \
		-e KEY_PRIVATE_PATH=$(KEY_PRIVATE_PATH) \
		-e ANSIBLE_REMOTE_USER=$(ANSIBLE_REMOTE_USER) \
		--entrypoint cli \
		ansible \
		bash

docker: docker-init docker-start docker-cli

play:
	@ansible-playbook $(PLAYBOOKS_DIR)/$(RUN_ARGS).yml -i $(INVENTORIES_DIR)/$(ANSIBLE_ENV)

play-dry-run:
	@ansible-playbook $(PLAYBOOKS_DIR)/$(RUN_ARGS).yml -i $(INVENTORIES_DIR)/$(ANSIBLE_ENV) --check --diff

uptime:
	@ansible -i $(INVENTORIES_DIR)/$(ANSIBLE_ENV) ssh -m raw -a "uptime"

gather-facts:
	@ansible -i $(INVENTORIES_DIR)/$(ANSIBLE_ENV) ssh -m setup

ping:
	@ansible -i $(INVENTORIES_DIR)/$(ANSIBLE_ENV) ssh --check --diff -m ping

graph:
	@ansible-inventory -i $(INVENTORIES_DIR)/$(ANSIBLE_ENV) --graph --vars

docker-init:
	@python $(TEST_PYTHON_FILE) -i "$(INVENTORIES_DIR)/$(ANSIBLE_ENV)" -s "$(TEST_SERVICE_DOCKER_FILE)" -o "$(TEST_COMPOSE_FILE)"

docker-start:
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" up -d --build --remove-orphans

docker-down:
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" down -v

docker-re:
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" up -d --build --force-recreate --remove-orphans

docker-cli:
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" exec ansible bash

.PHONY: test docker
