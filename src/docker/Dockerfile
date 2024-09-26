FROM alpine:latest

LABEL maintainer="dev_lau11@a.jlv6.com"

ARG WEB1_UID
ARG WEB1_USER
ARG WEB1_GID
ARG WEB1_GROUP

RUN <<EOF

    apk --update -t add --no-cache vim git hugo go npm tzdata --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
    rm -f /var/cache/apk/* /tmp/*
    rm -f /sbin/halt /sbin/poweroff /sbin/reboot

    ln -s /usr/share/zoneinfo/UTC /etc/localtime

    addgroup -g ${WEB1_GID} ${WEB1_GROUP}
    adduser -h /home/${WEB1_USER} -u ${WEB1_UID} -D -G ${WEB1_GROUP} ${WEB1_USER}

EOF

USER ${WEB1_USER}

RUN --mount=type=secret,id=GITHUB_USERNAME,env=GITHUB_USERNAME \
    --mount=type=secret,id=GITHUB_PAT,env=GITHUB_PAT \
    sh -c 'git config --global credential.helper "store --file=${HOME}/.git-credentials" \
    && echo "https://${GITHUB_USERNAME}:${GITHUB_PAT}@github.com/v6Org01/web1.git" > ${HOME}/.git-credentials'

CMD ["echo", "This is a dummy command. K8S config is taking over from here."]
