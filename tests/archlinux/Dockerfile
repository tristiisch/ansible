FROM archlinux:latest

# Install necessary packages
RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm systemd systemd-sysvcompat
RUN pacman -S --noconfirm \
    python openssh sudo \
    curl nano shadow \
    htop net-tools iputils openbsd-netcat bind \
	openssl

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



COPY <<EOF /entrypoint.sh
#!/bin/sh
set -eux

systemctl enable sshd

exec "\$@"
EOF
RUN chmod +x /entrypoint.sh

EXPOSE 22
STOPSIGNAL SIGRTMIN+3
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/lib/systemd/systemd"]
