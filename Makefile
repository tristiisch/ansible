SOURCES := ./src
INVENTORY := $(SOURCES)/inventory.yml
INVENTORY_DOCKER := $(SOURCES)/inventory-docker.yml

TEST_DIR := ./test
TEST_PYTHON_FILE := $(TEST_DIR)/docker-compose.py
TEST_COMPOSE_FILE := $(TEST_DIR)/docker-compose.yml
TEST_SERVICE_DOCKER_FILE := $(TEST_DIR)/debian/service.yml
TEST_SERVICE_ALL_FILE := $(TEST_DIR)/debian/service.yml,$(TEST_DIR)/ubuntu/service.yml,$(TEST_DIR)/rocky/service.yml,$(TEST_DIR)/suse/service.yml,$(TEST_DIR)/archlinux/service.yml
TEST_ANSIBLE_COMPOSE_FILE := $(TEST_DIR)/ansible/docker-compose.yml

docker-init-all:
	@python $(TEST_PYTHON_FILE) -i "$(INVENTORY)" -s "$(TEST_SERVICE_ALL_FILE)" -o "$(TEST_COMPOSE_FILE)"

docker-init-docker:
	@python $(TEST_PYTHON_FILE) -i "$(INVENTORY_DOCKER)" -s "$(TEST_SERVICE_DOCKER_FILE)" -o "$(TEST_COMPOSE_FILE)"

docker-start:
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" up -d --build --remove-orphans

docker-down:
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" down -v

docker-re:
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" up -d --build --force-recreate --remove-orphans

docker-cli:
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" exec ansible bash

# Local test using https://github.com/tristiisch/docker-stack
portainer:
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" cp ~/dev/devops/swarm_cluster/portainer dock-man-001:/opt/
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" exec dock-man-001 sh -c "cd /opt/portainer && $(MAKE)" 

docker-full: docker-init-docker docker-start
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" exec ansible sh -c "$(MAKE) play-docker ssh_account && $(MAKE) play-docker docker"
	$(MAKE) portainer

# Local test using https://github.com/tristiisch/webserver
web:
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" cp ~/dev/devops/web dock-man-001:/opt
	@docker compose -f "$(TEST_COMPOSE_FILE)" -f "$(TEST_ANSIBLE_COMPOSE_FILE)" exec dock-man-001 sh -c "cd /opt/swarm_cluster/web && $(MAKE)" 

.PHONY: test
