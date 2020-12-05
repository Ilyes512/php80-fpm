FROM php:8.0.0-fpm-buster as runtime

# Latest version of event at the moment: https://pecl.php.net/package/event
ARG PHP_EVENT_VERSION=3.0.1

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
    && docker-php-ext-enable event \
    && cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    # purge packages that where only needed for building php extensions
    && apt-get purge --assume-yes \
        $PHPIZE_DEPS \
        libicu-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        libevent-dev \
        libssl-dev \
    # remove all (non-hidden) files and dirs in /var/www/
    && rm -rf /var/www/* \
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

# ENV COMPOSER_ALLOW_SUPERUSER 1
# ENV PATH "/root/.composer/vendor/bin:${PATH}"

# Latest version of Composer: https://getcomposer.org/download
ARG COMPOSER_VERSION=2.0.8
ARG COMPOSER_SHA256=2021f0d52b446e0efe3c548cc058ab5671fa38cdbcf814e7911c7e9d71d61538
# Latest version of XDdebug: https://xdebug.org
ARG XDEBUG_VERSION=3.0.1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

    # install composer and xdebug
    # hadolint ignore=SC2086
RUN curl -fsSL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version="$COMPOSER_VERSION" \
    && echo "$COMPOSER_SHA256 */usr/local/bin/composer" | sha256sum -c - \
    && composer --ansi --version --no-interaction \
    # Needed for xdebug extension configuration
    && apt-get update \
    && apt-get install --assume-yes --no-install-recommends \
        $PHPIZE_DEPS \
        vim \
        git \
        unzip \
        sqlite3 \
    && pecl install "xdebug-$XDEBUG_VERSION" \
    && docker-php-ext-enable xdebug \
    && apt-get purge --assume-yes $PHPIZE_DEPS \
    && rm -rf /var/lib/apt/lists/* \
    && cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
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
