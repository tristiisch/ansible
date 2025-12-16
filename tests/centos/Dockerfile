FROM centos:latest

RUN yum install -y epel-release && \
    yum install -y \
    python3 openssh-server sudo \
    curl nano passwd \
    htop net-tools \
    iputils nmap-ncat bind-utils

RUN useradd -m president && \
    echo "president:P@ssword!" | chpasswd && \
    echo "president ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN ssh-keygen -A && \
	echo 'PermitRootLogin no' >> /etc/ssh/sshd_config.d/custom && \
	echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config.d/custom

USER president

EXPOSE 22

CMD ["sudo", "/usr/sbin/sshd", "-D"]
