# SOURCES := ./src
# INVENTORY_DOCKER := $(SOURCES)/inventory/docker/inventory.yml

# TEST_DIR := ./tests
# TEST_PYTHON_FILE := $(TEST_DIR)/docker-compose.py
# TEST_COMPOSE_FILE := $(TEST_DIR)/docker-compose.yml
# TEST_SERVICE_DOCKER_FILE := $(TEST_DIR)/debian/service.yml
# TEST_SERVICE_ALL_FILE := $(TEST_DIR)/debian/service.yml,$(TEST_DIR)/ubuntu/service.yml,$(TEST_DIR)/rocky/service.yml,$(TEST_DIR)/suse/service.yml,$(TEST_DIR)/archlinux/service.yml
# TEST_ANSIBLE_COMPOSE_FILE := $(TEST_DIR)/ansible/docker-compose.yml

include .env

ANSIBLE_DIR=./src
INVENTORIES_DIR=$(ANSIBLE_DIR)/inventory
PLAYBOOKS_DIR=$(ANSIBLE_DIR)/playbook
ROLES_DIR=$(ANSIBLE_DIR)/roles
RULE_WITH_ARGS=play

ifeq ($(filter $(RULE_WITH_ARGS), $(firstword $(MAKECMDGOALS))),$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif

docker:
	@docker build -f ./docker/ansible/Dockerfile -t ansible .
	@docker run -it --rm --name ansible \
		--dns-search $(DNS_DOMAIN) \
		-v ./:/app:ro \
		-v ~/.ssh:/home/ansible/.ansible_keys:ro \
		-e KEY_PRIVATE_PATH=$(KEY_PRIVATE_PATH) \
		-e ANSIBLE_REMOTE_USER=$(ANSIBLE_REMOTE_USER) \
		--entrypoint cli \
		ansible \
		bash

play:
# FIX ROLES_DIR
	ansible-playbook -M $(ROLES_DIR) $(PLAYBOOKS_DIR)/$(RUN_ARGS).yml -i $(INVENTORIES_DIR)/$(ANSIBLE_ENV)

uptime:
	ansible -i $(INVENTORIES_DIR)/$(ANSIBLE_ENV) ssh -m raw -a uptime

gather-facts:
	ansible -i $(INVENTORIES_DIR)/$(ANSIBLE_ENV) ssh -m setup

dry-run:
	ansible -i $(INVENTORIES_DIR)/$(ANSIBLE_ENV) ssh --check --diff -m ping


# docker-init:
# 	@python $(TEST_PYTHON_FILE) -i "$(INVENTORY_DOCKER)" -s "$(TEST_SERVICE_DOCKER_FILE)" -o "$(TEST_COMPOSE_FILE)"

# docker-start:
# 	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" up -d --build --remove-orphans

# docker-down:
# 	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" down -v

# docker-re:
# 	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" up -d --build --force-recreate --remove-orphans

# docker-cli:
# 	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" exec ansible bash

.PHONY: test docker
