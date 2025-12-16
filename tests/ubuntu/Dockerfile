FROM ubuntu:latest
ARG SHELL=/bin/bash

RUN sed -i 's|http://archive.ubuntu.com/ubuntu|http://fr.archive.ubuntu.com/ubuntu|g' /etc/apt/sources.list.d/ubuntu.sources

RUN apt update
RUN apt upgrade -y
RUN apt install -y systemd systemd-sysv

RUN apt install -y \
	python3 python3-pip python3-packaging openssh-server sudo \
	curl nano passwd \
	htop net-tools iputils-ping netcat-openbsd dnsutils

RUN sed -i "s|SHELL=/bin/sh|SHELL=$SHELL|g" /etc/default/useradd

RUN useradd -m president && \
	chmod 700 -R /home/president && \
	echo 'president:P@ssword!' | chpasswd && \
	echo 'president ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/president

RUN mkdir -p /run/sshd && \
	echo 'PermitRootLogin no' >> /etc/ssh/sshd_config.d/custom && \
	echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config.d/custom

# USER president

EXPOSE 22
STOPSIGNAL SIGRTMIN+3
CMD ["/lib/systemd/systemd"]

# CMD ["sudo", "/usr/sbin/sshd", "-D"]
