ARG BUILD_FROM=hassioaddons/base:3.1.0
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
        libxml2-dev=2.9.9-r1 \
        make=4.2.1-r2 \
        openssl-dev=1.1.1b-r1 \
        yarn=1.12.3-r0 \
    \
    && apk add --no-cache \
        bind-tools=9.12.3_p4-r1 \
        colordiff=1.0.18-r0 \
        git=2.20.1-r0 \
        libxml2-utils=2.9.9-r1 \
        lua-resty-http=0.12-r1 \
        mariadb-client=10.3.13-r0 \
        mosquitto-clients=1.5.6-r0 \
        ncurses=6.1_p20190105-r0 \
        net-tools=1.60_git20140218-r2 \
        nginx-mod-http-lua=1.14.2-r0 \
        nginx=1.14.2-r0 \
        openssl=1.0.2r-r0 \
        nmap=7.70-r3 \
        nodejs=10.14.2-r0 \
        openssh-client=7.9_p1-r4 \
        pwgen=2.08-r0 \
        py2-pip=10.0.1-r0 \
        python2=2.7.15-r1 \
        sqlite=3.25.3-r0 \
        sshfs=2.10-r2 \
        sudo=1.8.23-r2 \
        tmux=2.7-r0 \
        wget=1.20.1-r0 \
        zip=3.0-r6 \
        zsh-autosuggestions=0.4.2-r0 \
        zsh-syntax-highlighting=0.6.0-r0 \
        zsh=5.5.1-r0 \
    \
    && pip install yamllint==1.14.0 --no-cache-dir \
    \
    && yarn global add npm@4.6.1 modclean \
    \
    && curl -L -s -o /usr/bin/hassio \
        "https://github.com/home-assistant/hassio-cli/releases/download/2.1.0/hassio_${BUILD_ARCH}" \
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
    && curl -s -L \
        https://raw.githubusercontent.com/c9/install/master/link.sh | bash \
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
