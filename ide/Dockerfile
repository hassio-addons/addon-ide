ARG BUILD_FROM=hassioaddons/base:4.0.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Add env
ENV LANG="C.UTF-8" \
    TERM="xterm-256color"

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
# hadolint ignore=DL4001
ARG BUILD_ARCH
RUN \
    apk add --no-cache --virtual .build-dependencies \
        build-base=0.5-r1 \
        g++=8.3.0-r0 \
        libxml2-dev=2.9.9-r2 \
        make=4.2.1-r2 \
        openssl-dev=1.1.1c-r0 \
        yarn=1.16.0-r0 \
    \
    && apk add --no-cache \
        bind-tools=9.14.1-r1 \
        colordiff=1.0.18-r1 \
        git=2.22.0-r0 \
        libxml2-utils=2.9.9-r2 \
        lua-resty-http=0.13-r0 \
        mariadb-client=10.3.16-r0 \
        mosquitto-clients=1.6.3-r0 \
        ncurses=6.1_p20190518-r0 \
        net-tools=1.60_git20140218-r2 \
        nginx-mod-http-lua=1.16.0-r2 \
        nginx=1.16.0-r2 \
        nmap=7.70-r3 \
        nodejs=10.16.0-r0 \
        openssh-client=8.0_p1-r0 \
        openssl=1.1.1c-r0 \
        pwgen=2.08-r0 \
        py2-pip=18.1-r0 \
        python2=2.7.16-r1 \
        sqlite=3.28.0-r0 \
        sshfs=3.5.2-r0 \
        sudo=1.8.27-r0 \
        tmux=2.9a-r0 \
        wget=1.20.3-r0 \
        zip=3.0-r7 \
        zsh-autosuggestions=0.6.1-r0 \
        zsh-syntax-highlighting=0.6.0-r0 \
        zsh=5.7.1-r0 \
    \
    && pip install yamllint==1.16.0 --no-cache-dir \
    \
    && yarn global add npm@4.6.1 modclean \
    \
    && curl -L -s -o /usr/bin/hassio \
        "https://github.com/home-assistant/hassio-cli/releases/download/2.2.0/hassio_${BUILD_ARCH}" \
    \
    && git clone --branch master --single-branch --depth 1 \
        git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    \
    && sed -i -e "s#bin/ash#bin/zsh#" /etc/passwd \
    \
    && git clone --branch master --single-branch \
        https://github.com/c9/core.git /cloud9 \
    && git -C /cloud9 checkout c4d1c59dc8d6619bdca3dbe740291cd5cd26352c \
    \
    && npm set unsafe-perm true \
    \
    && npm -g install \
        node-gyp@3.8.0 \
    \
    && mkdir -p /root/.c9/node/bin \
    && pushd /root/.c9/node/bin \
    && ln -s "$(command -v node)" node \
    && ln -s "$(command -v npm)" npm \
    && popd \
    \
    && mkdir -p /root/.c9/bin \
    && pushd /root/.c9/bin \
    && ln -sf "$(command -v tmux)" tmux \
    && popd \
    \
    && mkdir -p /root/.c9/node_modules \
    && pushd /root/.c9 \
    && npm i https://github.com/risacher/pty.js \
    && npm i sqlite3@4.0.6 sequelize@2.0.0-beta.0 \
    && npm i https://github.com/c9/nak/tarball/c9 \
    && popd \
    \
    && echo 1 > /root/.c9/installed \
    \
    && /cloud9/scripts/install-sdk.sh \
    \
    && git -C /cloud9 reset HEAD --hard \
    \
    && rm -f -r /cloud9/.git \
    \
    && git -C /cloud9 init \
    \
    && git -C /cloud9 \
        -c user.name="Franck Nijhof" \
        -c user.email="frenck@addons.community" \
        commit \
        --allow-empty \
        -m "Hahaha Gotya!" \
    \
    && modclean --path /cloud9 --no-progress --keep-empty --run \
    \
    && yarn global add npm \
    \
    && yarn global remove modclean \
    \
    && yarn cache clean \
    \
    && apk del --purge .build-dependencies \
    \
    && rm -f -r \
        /tmp/*

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="IDE" \
    io.hass.description="Advanced IDE for Home Assistant, based on Cloud9 IDE" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="Advanced IDE for Home Assistant, based on Cloud9 IDE" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="IDE" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/t/community-hass-io-add-on-ide-based-on-cloud9/33810?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-ide/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-ide" \
    org.label-schema.vendor="Community Hass.io Add-ons"
