FROM php:8.0.2-fpm-buster as runtime

# Latest version of event-extension: https://pecl.php.net/package/event
ARG PHP_EVENT_VERSION=3.0.2

WORKDIR /var/www

    # install deps
    # hadolint ignore=SC2086
RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends \
        ca-certificates \
        openssl \
        curl \
        msmtp \
        # dependency of the php intl-extension
        libicu63 \
        # dependency of the php gd-extension
        libpng16-16 \
        libwebp6 \
        libjpeg62-turbo \
        libfreetype6 \
        # dependency of php zip-extension
        libzip4 \
        # dependency of php event-extension
        libevent-2.1-6 \
        libevent-openssl-2.1-6 \
        libevent-extra-2.1-6 \
    # install packages that are needed for building php extensions
    && apt-get install --assume-yes --no-install-recommends \
        $PHPIZE_DEPS \
        # dependency of the php intl-extension
        libicu-dev \
        # dependencies of php gd-extension
        libpng-dev \
        libwebp-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        # dependency of php zip-extension
        libzip-dev \
        # dependency of php event-extension
        libevent-dev \
        libssl-dev \
    # configure php gd-extension
    && docker-php-ext-configure gd \
        --enable-gd \
        --with-jpeg \
        --with-freetype \
        --with-webp \
    # install php extensions
    && docker-php-ext-install -j "$(nproc --all)" \
        pdo_mysql \
        intl \
        opcache \
        pcntl \
        gd \
        bcmath \
        zip \
        # dependency of php event-extension
        sockets \
    && pecl install "event-$PHP_EVENT_VERSION" \
    && docker-php-ext-enable event --ini-name docker-php-ext-zz-event.ini event \
    # purge packages that where only needed for building php extensions
    && apt-get purge --assume-yes \
        $PHPIZE_DEPS \
        libicu-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        libuv1-dev \
        libevent-dev \
        libssl-dev \
    && cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    # remove all (non-hidden) files and dirs in /var/www/
    && rm -rf /var/www/* \
    && apt-get autoremove --assume-yes \
    && apt-get clean --assume-yes \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

COPY files /

ARG VCS_REF
ARG CREATED
ARG VERSION=$PHP_VERSION
LABEL org.opencontainers.image.revision=$VCS_REF
LABEL org.opencontainers.image.version=$VERSION
LABEL org.opencontainers.image.created=$CREATED
LABEL org.opencontainers.image.title=php80-fpm
LABEL org.opencontainers.image.description="A PHP 8.0 based base image"
LABEL org.opencontainers.image.url=https://github.com/Ilyes512/docker-php80-fpm
LABEL org.opencontainers.image.documentation=https://github.com/Ilyes512/docker-php80-fpm/blob/master/README.md
LABEL org.opencontainers.image.vendor="ilyes512"
LABEL org.opencontainers.image.licenses=MIT
LABEL org.opencontainers.image.source=https://github.com/Ilyes512/docker-php80-fpm

FROM runtime as builder

ENV PATH "/root/.composer/vendor/bin:${PATH}"

# Latest version of Composer: https://getcomposer.org/download
ARG COMPOSER_VERSION=2.0.9
ARG COMPOSER_SHA256=24faa5bc807e399f32e9a21a33fbb5b0686df9c8850efabe2c047c2ccfb9f9cc
# Latest version of XDdebug: https://pecl.php.net/package/xdebug
ARG XDEBUG_VERSION=3.0.2

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

    # install composer and xdebug
    # hadolint ignore=SC2086
RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends \
        # Needed for xdebug extension configuration
        $PHPIZE_DEPS \
        vim \
        git \
        unzip \
        sqlite3 \
    && curl -fsSL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version="$COMPOSER_VERSION" \
    && echo "$COMPOSER_SHA256 */usr/local/bin/composer" | sha256sum -c - \
    && composer --ansi --version \
    && pecl install "xdebug-$XDEBUG_VERSION" \
    && docker-php-ext-enable xdebug \
    && cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && apt-get purge --assume-yes \
        $PHPIZE_DEPS \
    && apt-get autoremove --assume-yes \
    && apt-get clean --assume-yes \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

ARG VCS_REF
ARG CREATED
ARG VERSION=$PHP_VERSION
LABEL org.opencontainers.image.revision=$VCS_REF
LABEL org.opencontainers.image.version=$VERSION
LABEL org.opencontainers.image.created=$CREATED
LABEL org.opencontainers.image.title=php80-fpm
LABEL org.opencontainers.image.description="A PHP 8.0 based base image"
LABEL org.opencontainers.image.url=https://github.com/Ilyes512/docker-php80-fpm
LABEL org.opencontainers.image.documentation=https://github.com/Ilyes512/docker-php80-fpm/blob/master/README.md
LABEL org.opencontainers.image.vendor="ilyes512"
LABEL org.opencontainers.image.licenses=MIT
LABEL org.opencontainers.image.source=https://github.com/Ilyes512/docker-php80-fpm

FROM builder as vscode

RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends \
        openssh-client \
        sudo \
        # Live Share (Extension) deps
        libkrb5-3 \
        zlib1g \
        libicu63 \
        gnome-keyring \
        libsecret-1-0 \
        desktop-file-utils \
        x11-utils \
    && apt-get autoremove --assume-yes \
    && apt-get clean --assume-yes \
    && rm -rf /var/lib/apt/lists/*
