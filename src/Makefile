SOURCES				:=	.
INVENTORY_DOCKER 	:=	$(SOURCES)/inventory/docker
INVENTORY_VM	 	:=	$(SOURCES)/inventory/vm
INVENTORY_LAB	 	:=	$(SOURCES)/inventory/lab
PLAYBOOK_DIR		:=	$(SOURCES)/playbook
DEFAULT_GROUP		:=	all
RULE_WITH_ARGS		:=	play play-docker play-vm play-lab

ifeq ($(filter $(RULE_WITH_ARGS), $(firstword $(MAKECMDGOALS))),$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif

play-docker:
	ansible-playbook -i $(INVENTORY_DOCKER) $(PLAYBOOK_DIR)/$(RUN_ARGS).yml

play-vm:
	ansible-playbook -i $(INVENTORY_VM) $(PLAYBOOK_DIR)/$(RUN_ARGS).yml

play-lab:
	ansible-playbook -i $(INVENTORY_LAB) $(PLAYBOOK_DIR)/$(RUN_ARGS).yml

# uptime:
# 	# ansible -i $(INVENTORY) $(DEFAULT_GROUP) -m command -a uptime
# 	ansible -i $(INVENTORY) $(DEFAULT_GROUP) -m raw -a uptime

# gather-facts:
# 	ansible -i $(INVENTORY) $(DEFAULT_GROUP) -m setup

# dry-run:
# 	ansible -i $(INVENTORY) $(DEFAULT_GROUP) --check --diff -m ping

graph-docker:
	@ansible-inventory -i $(INVENTORY_DOCKER) --graph --vars

graph-vm:
	@ansible-inventory -i $(INVENTORY_VM) --graph --vars

graph-lab:
	@ansible-inventory -i $(INVENTORY_LAB) --graph --vars
