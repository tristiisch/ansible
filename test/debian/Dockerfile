FROM debian:latest
ARG SHELL=/bin/bash

RUN sed -i 's|http://deb.debian.org/debian|http://ftp.fr.debian.org/debian|g' /etc/apt/sources.list.d/debian.sources

RUN apt update
RUN apt upgrade -y
RUN apt install -y systemd systemd-sysv
VOLUME ["/sys/fs/cgroup"]

RUN apt install -y \
	python3 openssh-server sudo \
	curl nano passwd \
	htop net-tools iputils-ping netcat-openbsd dnsutils

# RUN mkdir -p /run/systemd && echo 'docker' > /run/systemd/container

RUN sed -i "s|SHELL=/bin/sh|SHELL=$SHELL|g" /etc/default/useradd

RUN useradd -m president \
	&& chmod 700 -R /home/president \
	&& echo 'president:P@ssword!' | chpasswd \
	&& echo 'president ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/president

RUN mkdir -p /run/sshd \
	&& echo 'PermitRootLogin no' >> /etc/ssh/sshd_config.d/custom \
	&& echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config.d/custom

EXPOSE 80
STOPSIGNAL SIGRTMIN+3
CMD ["/lib/systemd/systemd"]
