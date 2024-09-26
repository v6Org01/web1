FROM alpine:latest

LABEL maintainer="dev_lau11@a.jlv6.com"

ARG HUGO_DIR
ARG HUGO_TITLE
ARG HUGO_URI
ARG TZ
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

WORKDIR ${HUGO_DIR}

RUN <<EOV

    npm run project-setup 
    npm install

    find . -type f -exec sed -i -e 's/127.0.0.1/0.0.0.0/g' {} \;
    find . -type f -exec sed -i -e 's/localhost/${HUGO_URI}/g' {} \;
    sed -i 's/"dev": "hugo server"/"dev": "hugo server --bind=0.0.0.0"/' ./package.json
    sed -i 's/^baseURL =.*/baseURL = https:\/\/${HUGO_URI}/' ./hugo.toml
    sed -i 's/^title =.*/title = "${HUGO_TITLE}"/' ./hugo.toml
    sed -i 's/^timeZone =.*/timeZone = "${TZ}"/' ./hugo.toml

    mkdir $HOME/.vim && cd $HOME/.vim
    wget -O ./vim-markdown-master.tar.gz https://github.com/preservim/vim-markdown/archive/master.tar.gz
    tar --strip=1 -zxf ./vim-markdown-master.tar.gz

EOV

CMD ["/usr/bin/npm", "run", "dev"]
