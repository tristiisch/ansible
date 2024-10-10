import argparse
import itertools
import json
import random
import re
import yaml
from typing import Dict, Any

def load_yaml(file_path: str) -> Dict[str, Any]:
	"""Load the Ansible inventory from the specified file."""
	with open(file_path, 'r') as file:
		return yaml.safe_load(file)

def initialize_docker_compose() -> Dict[str, Any]:
	"""Initialize the base structure of the Docker Compose YAML."""
	return {
		'services': {}
	}

def extract_hosts(inventory: Dict[str, Any]) -> Dict[str, Any]:
	"""Extract the hosts from the inventory."""
	hosts_keys = []

	# Iterate through top-level keys
	for _, value in inventory.items():
		if not isinstance(value, dict):
			continue
		sub_items = value.items()
		for sub_key, sub_value in sub_items:
			if not isinstance(sub_key, str):
				continue
			if sub_key.casefold() == 'hosts' and isinstance(sub_value, dict):
				hosts_keys += sub_value.keys()
	return hosts_keys

def expand_hosts(docker_hosts: Dict[str, Any]) -> list[str]:
	"""Add services for each docker host to the Docker Compose structure."""
	multiple_host_resolved = []
	for host_key in docker_hosts:
		multiple_host_resolved += __resolve_multiple_host(host_key)
	return multiple_host_resolved

def __resolve_multiple_host(host_key: str) -> list[str]:
	pattern = r'\[(\d+):(\d+)\]'
	matches = re.findall(pattern, host_key)
	if not matches:
		return [host_key]

	expanded_strings = []
	expanded_strings.append(host_key)

	for match in matches:
		start = int(match[0])
		end = int(match[1])

		new_expanded_strings = []
		for i in range(start, end + 1):
			for _, existing_string in enumerate(expanded_strings):
				new_string = re.sub(pattern, str(i).zfill(len(match[0])), existing_string, count=1)
				new_expanded_strings.append(new_string)
		expanded_strings = new_expanded_strings

	return expanded_strings

def add_services_to_compose(docker_compose: Dict[str, Any], docker_services_settings: list[Dict[str, Any]] | None, docker_hosts: Dict[str, Any]) -> None:
	"""Add services for each docker host to the Docker Compose structure."""
	for host in docker_hosts:
		docker_hosts_expanded = expand_hosts(docker_hosts)
		docker_service_settings_iterator = __round_robin_list(docker_services_settings)
		for docker_host_expanded in docker_hosts_expanded:
			service_name, service_entry = __create_service_entry(docker_host_expanded, next(docker_service_settings_iterator))
			docker_compose['services'][service_name] = service_entry

def __round_robin_list(elements):
    iterator = itertools.cycle(elements)
    while True:
        yield next(iterator)

def __create_service_entry(host: str, docker_services_settings: Dict[str, Any] | None) -> tuple[str, Dict[str, Any]]:
	"""Create a service entry for a given host."""
	service_name = host.lower()
	if docker_services_settings is not None:
		service_params = docker_services_settings
	else:
		service_params = {
			'image': 'debian:latest',
			'command': 'tail -f /dev/null'
		}
	return service_name, service_params

def save_docker_compose(file_path: str, docker_compose: Dict[str, Any]) -> None:
	"""Save the Docker Compose YAML to a file."""
	with open(file_path, 'w') as f:
		yaml.dump(docker_compose, f, default_flow_style=False)

def main() -> None:
	parser = argparse.ArgumentParser(description="Argument Parser for your program")
	parser.add_argument('-i', '--input', required=True,
						help='Path to Ansible inventory YAML file. Default ./inventory.yml')
	parser.add_argument('-s', '--service-base', default=None,
						help='Path for settings of hosts.')
	parser.add_argument('-o', '--output', default=None,
						help='Output for Docker Compose YAML file')
	args = parser.parse_args()

	ansible_inventory_path = args.input
	docker_compose_path = args.output
	service_base_path = args.service_base

	inventory_data = load_yaml(ansible_inventory_path)
	if service_base_path is not None:
		paths = service_base_path.split(',')
		docker_services_settings = []
		for path in paths:
			docker_services_settings.append(load_yaml(path))
	else:
		docker_services_settings = None
	docker_compose_data = initialize_docker_compose()
	docker_hosts = extract_hosts(inventory_data)
	add_services_to_compose(docker_compose_data, docker_services_settings, docker_hosts)

	if docker_compose_path is not None:
		save_docker_compose(docker_compose_path, docker_compose_data)
		print(f"Docker Compose file '{docker_compose_path}' has been generated.")

	print(yaml.dump(docker_compose_data, default_flow_style=False))

if __name__ == "__main__":
	main()
