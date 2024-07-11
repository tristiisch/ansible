#!/bin/sh
set -eux

# Check if the system is Ubuntu or Debian
if [ ! -f /etc/os-release ]; then
    echo "Error: Unable to determine the distribution. This script requires Ubuntu or Debian."
    exit 1
fi

. /etc/os-release
if [ "$ID" != "ubuntu" ] && [ "$ID" != "debian" ]; then
	echo "Error: This script is only compatible with Ubuntu or Debian."
	exit 1
fi
if [ -z "${VERSION_CODENAME+x}" ]; then
	echo "Error: The version codename for $ID could not be found."
	exit 1
fi

# Add PPA repo
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y

# Install Python
sudo apt install -y python3.12
