ARG BUILD_FROM=hassioaddons/base-amd64:1.4.2
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Add env
ENV LANG="C.UTF-8" \
    TERM="xterm-256color"

# Setup base
# hadolint ignore=DL4001
ARG BUILD_ARCH
RUN \
    apk add --no-cache --virtual .build-dependencies \
        build-base=0.5-r0 \
        g++=6.4.0-r5 \
        libxml2-dev=2.9.7-r0 \
        make=4.2.1-r0 \
        openssl-dev=1.0.2o-r0 \
        yarn=1.3.2-r0 \
    \
    && apk add --no-cache \
        bind-tools=9.11.3-r0 \
        git=2.15.2-r0 \
        libxml2-utils=2.9.7-r0 \
        mariadb-client=10.1.32-r0 \
        mosquitto-clients=1.4.15-r0 \
        ncurses=6.0_p20171125-r0 \
        net-tools=1.60_git20140218-r1 \
        nginx=1.12.2-r3 \
        nmap=7.60-r2 \
        nodejs-current=9.2.1-r1 \
        openssh-client=7.5_p1-r8 \
        openssl=1.0.2o-r0 \
        pwgen=2.08-r0 \
        py2-pip=9.0.1-r1 \
        python2=2.7.14-r2 \
        sqlite=3.21.0-r1 \
        sshfs=2.10-r2 \
        sudo=1.8.21_p2-r1 \
        tmux=2.6-r0 \
        wget=1.19.5-r0 \
        zip=3.0-r4 \
        zsh=5.4.2-r1 \
    \
    && pip install yamllint --no-cache-dir \
    \
    && yarn global add npm@4.6.1 modclean \
    \
    && curl -L -s -o /usr/bin/hassio \
        "https://github.com/home-assistant/hassio-cli/releases/download/1.3.1/hassio_${BUILD_ARCH}" \
    \
    && git clone --branch master --single-branch --depth 1 \
        git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    \
    && sed -i -e "s#bin/ash#bin/zsh#" /etc/passwd \
    \
    && git clone --branch master --single-branch \
        https://github.com/c9/core.git /cloud9 \
    && git -C /cloud9 checkout 15911b3ed65e69efd27d19683a2ac90c69ca4242 \
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

# Build arugments
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
