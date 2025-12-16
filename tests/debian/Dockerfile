FROM debian:trixie
ARG SHELL=/bin/bash

# Use French mirror
RUN sed -i 's|http://deb.debian.org/debian|http://ftp.fr.debian.org/debian|g' /etc/apt/sources.list.d/debian.sources

RUN apt update && \
	apt upgrade -y && \
	apt install -y systemd systemd-sysv \
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

STOPSIGNAL SIGRTMIN+3
VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]
# CMD /lib/systemd/systemd && journalctl -f
