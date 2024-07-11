FROM alpine:latest
ARG SHELL=/bin/ash
RUN sed -i 's|https://dl-cdn.alpinelinux.org/alpine|https://mirrors.ircam.fr/pub/alpine|g' /etc/apk/repositories

RUN apk update && apk add --no-cache  \
	openrc \
	python3 openssh-server sudo \
	curl nano shadow \
	htop net-tools iputils netcat-openbsd bind-tools


RUN ssh-keygen -A \
	&& rc-update add sshd default

RUN echo "SHELL=$SHELL" >> /etc/adduser.conf

RUN adduser -D president \
	&& chmod 700 -R /home/president \
	&& echo 'president:P@ssword!' | chpasswd \
	&& echo 'president ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/president

RUN ssh-keygen -A \
	&& mkdir -p /run/sshd \
	&& echo 'PermitRootLogin no' >> /etc/ssh/sshd_config.d/custom \
	&& echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config.d/custom

# RUN rc-status && touch /run/openrc/softlevel

# USER president

EXPOSE 22

# CMD ["sudo", "/usr/sbin/sshd", "-D"]
# CMD ["sudo", "/sbin/openrc", "default"]
# CMD ["sudo", "/sbin/init"]
CMD ["/sbin/init"]
