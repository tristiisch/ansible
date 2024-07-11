FROM debian:latest
ARG SHELL=/bin/bash

RUN sed -i 's|http://deb.debian.org/debian|http://ftp.fr.debian.org/debian|g' /etc/apt/sources.list.d/debian.sources

RUN apt update && apt upgrade -y && apt install -y \
	sshpass \
	htop net-tools iputils-ping netcat-openbsd dnsutils \
	curl nano sudo \
	make

RUN DEBIAN_VERSION=$(grep VERSION_CODENAME /etc/os-release | cut -d'=' -f2) \
	&& case $DEBIAN_VERSION in \
		bookworm) UBUNTU_CODENAME_EQUIVALENT=jammy ;; \
		bullseye) UBUNTU_CODENAME_EQUIVALENT=focal ;; \
		buster) UBUNTU_CODENAME_EQUIVALENT=bionic ;; \
		*) echo "Unknown Debian version: $DEBIAN_VERSION" && exit 1 ;; \
	esac \
	&& KEY_PATH=/etc/apt/keyrings/ansible.asc \
	&& curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" -o "$KEY_PATH" \
	&& sudo chmod a+r "$KEY_PATH" \
	&& echo "deb [signed-by=$KEY_PATH] http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME_EQUIVALENT main" | sudo tee /etc/apt/sources.list.d/ansible.list \
	&& apt update \
	&& apt install -y ansible

RUN sed -i "s|SHELL=/bin/sh|SHELL=$SHELL|g" /etc/default/useradd

RUN useradd -m president \
	&& chmod 700 -R /home/president \
	&& echo 'president:P@ssword!' | chpasswd \
	&& echo 'president ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/president \
	&& useradd -m ansible \
	&& chmod 700 -R /home/ansible \
	&& echo 'ansible ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/ansible

WORKDIR /opt/ansible

STOPSIGNAL SIGKILL

USER ansible

CMD tail -f /dev/null
