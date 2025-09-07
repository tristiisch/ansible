FROM alpine/ansible:2.18.6

RUN apk add make sshpass
RUN adduser -u 1000 -D ansible

COPY --chmod=555 <<EOF /cli.sh
#!/bin/bash
eval $(ssh-agent -s)
ssh-add \${KEY_PRIVATE_PATH:?}
exec "\$@"
EOF
RUN ln -s /cli.sh /bin/cli

USER ansible
WORKDIR /app

RUN ssh-keygen -t ed25519 -f ~/.ssh/ed25519
COPY --chmod=644 <<EOF ~/.ssh/config
Host *
    IdentityFile ~/.ssh/ed25519
EOF

# ENTRYPOINT ["/entrypoint.sh"]
# CMD ["tail", "-f", "/dev/null"]
CMD ["bash"]
