FROM opensuse/leap:latest

RUN zypper refresh
RUN zypper install -y systemd systemd-sysvinit

RUN zypper install -y \
    python3 openssh sudo \
    curl nano shadow \
    htop net-tools-deprecated iputils netcat-openbsd bind-utils

RUN useradd -m president \
	&& chmod 700 -R /home/president \
	&& echo 'president:P@ssword!' | chpasswd \
	&& echo 'president ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/president

RUN ssh-keygen -A \
	&& echo 'PermitRootLogin no' >> /etc/ssh/sshd_config.d/custom \
	&& echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config.d/custom

RUN mkdir -p /run/systemd \
	&& echo 'docker' > /run/systemd/container

# USER president
# CMD ["sudo", "/usr/sbin/sshd", "-D"]

EXPOSE 22
STOPSIGNAL SIGRTMIN+3
CMD ["/usr/sbin/init"]
