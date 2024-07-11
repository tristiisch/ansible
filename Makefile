SOURCES := ./src
INVENTORY := $(SOURCES)/inventory.yml
PLAYBOOK_DIR := $(SOURCES)/playbook
DEFAULT_GROUP := all

TEST_DIR := ./test
TEST_PYTHON_FILE := $(TEST_DIR)/docker-compose.py
TEST_COMPOSE_FILE := $(TEST_DIR)/docker-compose.yml
# TEST_SERVICE_FILE := $(TEST_DIR)/debian/service.yml,$(TEST_DIR)/ubuntu/service.yml,$(TEST_DIR)/alpine/service.yml
# TEST_SERVICE_FILE := $(TEST_DIR)/debian/service.yml,$(TEST_DIR)/ubuntu/service.yml,$(TEST_DIR)/rockylinux/service.yml,$(TEST_DIR)/suse/service.yml,$(TEST_DIR)/archlinux/service.yml,$(TEST_DIR)/centos/service.yml
TEST_SERVICE_FILE := $(TEST_DIR)/debian/service.yml,$(TEST_DIR)/ubuntu/service.yml,$(TEST_DIR)/rocky/service.yml,$(TEST_DIR)/suse/service.yml,$(TEST_DIR)/archlinux/service.yml
TEST_ANSIBLE_COMPOSE_FILE := $(TEST_DIR)/ansible/docker-compose.yml

play-chrony:
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK_DIR)/chrony.yml

play-ssh-user:
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK_DIR)/ssh_account.yml

ping:
	ansible -i $(INVENTORY) $(DEFAULT_GROUP) -m ping

uptime:
	# ansible -i $(INVENTORY) $(DEFAULT_GROUP) -m command -a uptime
	ansible -i $(INVENTORY) $(DEFAULT_GROUP) -m raw -a uptime

gather-facts:
	ansible -i $(INVENTORY) $(DEFAULT_GROUP) -m setup

dry-run:
	ansible -i $(INVENTORY) $(DEFAULT_GROUP) --check --diff -m ping

print-docker-version:
	ansible -i $(INVENTORY) docker -m debug -a 'msg={{ docker_version }}'

graph:
	@ansible-inventory -i $(INVENTORY) --graph --vars

docker: docker-start

docker-init:
	@python $(TEST_PYTHON_FILE) -i "$(INVENTORY)" -s "$(TEST_SERVICE_FILE)" -o "$(TEST_COMPOSE_FILE)"

docker-start: docker-init
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" up -d --build --remove-orphans

docker-down:
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" down -v

docker-re: docker-init
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" up -d --build --force-recreate --remove-orphans

docker-cli:
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" exec ansible bash

.PHONY: test
