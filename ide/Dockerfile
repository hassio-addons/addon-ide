ARG BUILD_FROM=hassioaddons/base-amd64:1.1.0
FROM ${BUILD_FROM}

# Add env
ENV LANG="C.UTF-8" \
    TERM="xterm-256color"

# Setup base
RUN \
    apk add --no-cache --virtual .build-dependencies \
        build-base \
        g++ \
        libxml2-dev \
        make \
        openssl-dev \
        yarn \
    \
    && apk add --no-cache \
        bind-tools \
        git \
        libxml2-utils \
        mariadb-client \
        mosquitto-clients \
        ncurses \
        net-tools \
        nginx \
        nodejs-current \
        openssh-client \
        openssl \
        py-pip \
        python \
        sshfs \
        sudo \
        tmux \
        wget \
        zsh \
    \
    && pip install yamllint --no-cache-dir \
    \
    && yarn global add npm@4.6.1 modclean \
    \
    && git clone --depth 1 \
        git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    \
    && sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd \
    \
    && git clone --depth 1 \
        https://github.com/c9/core.git /cloud9 \
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
ARG BUILD_ARCH
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
    org.label-schema.url="https://addons.community" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-ide/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-ide" \
    org.label-schema.vendor="Community Hass.io Add-ons"
