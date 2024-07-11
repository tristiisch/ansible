FROM rockylinux:9

ENV container docker
RUN dnf update -y
RUN dnf install -y epel-release
# RUN dnf install -y epel-release firewalld \
# RUN (cd /usr/lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done) \
# 	&& rm -f /usr/lib/systemd/system/multi-user.target.wants/* \
# 	&& rm -f /etc/systemd/system/*.wants/* \
# 	&& rm -f /usr/lib/systemd/system/local-fs.target.wants/* \
# 	&& rm -f /usr/lib/systemd/system/sockets.target.wants/*udev* \
# 	&& rm -f /usr/lib/systemd/system/sockets.target.wants/*initctl* \
# 	&& rm -f /usr/lib/systemd/system/basic.target.wants/* \
# 	&& rm -f /usr/lib/systemd/system/anaconda.target.wants/*
VOLUME ["/sys/fs/cgroup"]

RUN dnf install -y --allowerasing \
	python3 openssh-server sudo \
	curl nano passwd \
	htop net-tools \
	iputils nmap-ncat bind-utils \
	&& yum clean all

RUN useradd -m president && \
	echo "president:P@ssword!" | chpasswd && \
	echo "president ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN ssh-keygen -A
COPY <<EOF /etc/ssh/sshd_config.d/custom

PermitRootLogin no

Match User president
	PasswordAuthentication yes
EOF

# COPY <<EOF /toolbox.sh
# #!/bin/sh
# set -eux

# # firewall-cmd --permanent --add-service=ssh
# # firewall-cmd --reload
# systemctl start systemd-user-sessions

# exec "\$@"
# EOF
# RUN chmod +x /toolbox.sh

# COPY <<EOF /etc/systemd/system/toolbox.service
# [Unit]
# Description=Run custom command before network is up
# # After=basic.target
# After=firewalld.target
# # Before=network.target

# [Service]
# Type=simple
# ExecStart=/toolbox.sh

# [Install]
# WantedBy=multi-user.target
# EOF

COPY <<EOF /entrypoint.sh
#!/bin/sh
set -eux

# systemctl start firewalld
# systemctl start sshd
# systemctl start systemd-user-sessions

# systemctl enable toolbox
# systemctl enable firewalld
systemctl enable sshd
# systemctl enable systemd-user-sessions

exec "\$@"
EOF
RUN chmod +x /entrypoint.sh

EXPOSE 22
STOPSIGNAL SIGRTMIN+3
CMD ["/usr/sbin/init"]
# ENTRYPOINT ["/entrypoint.sh"]
# ENTRYPOINT ["/entrypoint.sh"]
# CMD ["/usr/sbin/init"]
