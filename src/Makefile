SOURCES				:=	.
INVENTORY			:=	$(SOURCES)/inventory.yml
INVENTORY_DOCKER 	:=	$(SOURCES)/inventory-docker.yml
INVENTORY_VM	 	:=	$(SOURCES)/inventory-vm.yml
PLAYBOOK_DIR		:=	$(SOURCES)/playbook
DEFAULT_GROUP		:=	all
RULE_WITH_ARGS		:=	play play-docker play-vm

ifeq ($(filter $(RULE_WITH_ARGS), $(firstword $(MAKECMDGOALS))),$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif

play:
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK_DIR)/$(RUN_ARGS).yml

play-docker:
	ansible-playbook -i $(INVENTORY_DOCKER) $(PLAYBOOK_DIR)/$(RUN_ARGS).yml

play-vm:
	ansible-playbook -i $(INVENTORY_VM) $(PLAYBOOK_DIR)/$(RUN_ARGS).yml

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
