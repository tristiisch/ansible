# Ansible Sandbox

This project leverages **Ansible** to automate the configuration and deployment of both **VMs** and **Docker containers**. The structure supports multiple Linux distributions and is ideal for testing and setting up environments using **VMs** or **Docker**.

## Features

- **Multi-environment Support**: Works with various Linux distributions, including Debian, Ubuntu, ArchLinux, CentOS, Rocky, Suse, and Alpine.
- **Ansible Playbooks**: Automate the configuration of VMs or Docker containers with reusable Ansible roles.
- **VM and Docker Management**: Choose between managing VMs or setting up lightweight environments with Docker containers.
- **Customizable Roles**: Pre-defined Ansible roles for tasks such as Docker installation, NGINX configuration, SSH key management, and more.
- **Simulated VM environments with Docker**: Useful for testing, where Docker containers act as lightweight VM replacements.

## Prerequisites

- **Ansible**: For running playbooks and managing infrastructure.
- **Docker**: For containerized environments.
- **VMWare Workstation Pro** (or any virtualization software): For managing VMs.
- **Python 3** and **Make**: Required in the Ansible VM for running playbooks.
- **SSH**: Ensure SSH access is configured on all target VMs.

## Usage

### VM Setup

1. **Configure VMs**:
   - Update `src/inventory-vm.yml` with your VMs' details.
   - Mount the `./src` directory into the Ansible VM.
   - Install **Ansible**, **Python3**, and **Make** in the Ansible VM.
   - Ensure the Ansible VM and other VMs are on the same network.
   - Set up **SSH** access on your VMs and specify the private key in `src/ansible.cfg`.

2. **Run Playbooks**:
   - Connect to Ansible VM, and run
     ```bash
     make play-vm <playbook>
     ```

### Docker Setup

#### 1. Simulate VMs with Docker

- **Step 1**: Define your container setup in `./tests/<os>/service.yml`, including ports and services.
- **Step 2**: Update the Ansible inventory in `./src/inventory.yml` with your containers.
- **Step 3**: Run the following command to automatically generate the Docker Compose file based on your Ansible inventory:
  ```bash
  make docker-init-all
  ```

#### 2. Docker in Docker (DinD)

- **Step 1**: Initialize the Docker setup on Debian (configured for Docker in Docker):
  ```bash
  make docker-init-docker
  ```
- **Step 2**: Start your containers:
  ```bash
  make docker-start
  ```

#### Manage Docker Containers

- Start the Docker containers:
  ```bash
  make docker-start
  ```
- Access the Ansible container’s terminal:
  ```bash
  make docker-cli
  ```
- Stop and remove containers and volumes:
  ```bash
  make docker-down
  ```
- Run Ansible playbooks on your Docker containers:
  ```bash
  make play-vm <playbook>
  ```

## Available Playbooks

This Ansible project includes several playbooks to automate the setup and configuration of key services such as Chrony, Docker, NGINX, Python, and SSH across various hosts. Below is an overview of each playbook and its functionality.

### Playbooks Overview

1. **chrony**
   **Purpose**: Configures Chrony for time synchronization.
   **Features**:
   - Installs and configures Chrony for NTP services.
   - Ensures that time synchronization is set up correctly across defined hosts.

2. **docker**
   **Purpose**: Installs Docker and sets up a Docker Swarm cluster.
   **Features**:
   - Installs Docker.
   - Configures Docker daemon settings.
   - Creates a Docker Swarm cluster.
   - Manages Docker Swarm by gathering information, obtaining join tokens, and adding managers and workers.
   - Repair a broken Docker Swarm cluster.

3. **information**
   **Purpose**: Gathers information from servers.
   **Features**:
   - Collects system and network information from all hosts.
   - Useful for obtaining an overview of the infrastructure.

4. **network_vware**
   **Purpose**: Configures network settings.
   **Features**:
   - Disables specific network transmission options to resolve issues with VMWare.

5. **nginx**
   **Purpose**: Installs and configures NGINX web server.
   **Features**:
   - Installs NGINX on the web servers.
   - Configures NGINX with custom templates.
   - Runs tests to verify the NGINX setup.

6. **python**
   **Purpose**: Installs Python on all servers.
   **Features**:
   - Installs Python on the target hosts.
   - Ensures Python is available for running other roles and tasks.

7. **ssh**
   **Purpose**: Manages SSH keys and accounts.
   **Features**:
   - Generates and deploys SSH keys to specified hosts.
   - Creates SSH users and tests SSH connections.

## Visualize Inventory

You can view the Ansible inventory structure using the following commands:

- **VM Inventory Graph**:
  ```bash
  make graph-vm
  ```
- **Docker Inventory Graph**:
  ```bash
  make graph-docker
  ```

## Contribution

- Contributions to improve compatibility with other Linux distributions are welcome! Please open a pull request if you make improvements.
