FROM php:8.0.0alpha2-fpm-alpine3.12 as runtime

# Latest version of UV at the moment: https://pecl.php.net/package/uv
ARG PHP_UV_VERSION=0.2.4
# Latest version of Pickle at the moment: https://api.github.com/repos/FriendsOfPHP/pickle/releases/latest
ARG PICKLE_VERSION=v0.6.0

WORKDIR /var/www

    # install deps
    # hadolint ignore=SC2086
RUN apk add --no-cache --upgrade \
        ca-certificates \
        openssl \
        curl \
        msmtp \
        # dependency of the php intl-extension
        icu \
        # dependency of the php gd-extension
        libpng \
        libwebp \
        libjpeg-turbo \
        freetype \
        # dependency of php zip-extension
        libzip \
        # dependency of php uv-extension
        libuv \
    # install needed php extension configuration/installing packages
    && apk add --no-cache --upgrade --virtual .build \
        $PHPIZE_DEPS \
        # dependency of the php intl-extension
        icu-dev \
        # dependencies of php gd-extension
        libpng-dev \
        libwebp-dev \
        libjpeg-turbo-dev \
        freetype-dev \
        # dependency of php zip-extension
        libzip-dev \
        # dependency of php uv-extension
        libuv-dev \
    # configure php gd-extension
    && docker-php-ext-configure gd \
        --enable-gd \
        --with-jpeg \
        --with-freetype \
        --with-webp \
    # install php extensions
    && docker-php-ext-install -j "$(getconf _NPROCESSORS_ONLN)" \
        pdo_mysql \
        intl \
        opcache \
        pcntl \
        gd \
        bcmath \
        zip \
    && curl -fsSLo /usr/local/bin/pickle "https://github.com/FriendsOfPHP/pickle/releases/download/$PICKLE_VERSION/pickle.phar" \
    && chmod +x /usr/local/bin/pickle \
    # && pickle install "uv@$PHP_UV_VERSION" --defaults \
    # && docker-php-ext-enable uv \
    && cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && apk del .build \
    # remove all (non-hidden) files and dirs in /var/www/
    && rm -rf /var/www/* \
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

# Latest version of Composer: https://getcomposer.org/download/
ARG COMPOSER_VERSION=2.0.0-alpha2
ARG COMPOSER_SHA256=6490fc59e48bf1ea5f3301cde071a56dc63e9a7dbb5540a94501bec570cabd5d
# Latest version of XDdebug: https://xdebug.org/
ARG XDEBUG_VERSION=2.9.6

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

    # install composer and xdebug
    # hadolint ignore=SC2086
RUN curl -fsSL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version="$COMPOSER_VERSION" \
    && echo "$COMPOSER_SHA256 */usr/local/bin/composer" | sha256sum -c - \
    && composer --ansi --version --no-interaction \
    # Install some builder-only apps
    && apk add --no-cache --upgrade --no-progress \
        vim \
        git \
        unzip \
        sqlite \
    # Needed for xdebug extension configuration (is removed later on, see --virtual)
    && apk add --no-cache --upgrade --virtual .build $PHPIZE_DEPS \
    # && pickle install "xdebug@$XDEBUG_VERSION" \
    # && docker-php-ext-enable xdebug \
    && cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && apk del .build \
    && rm -rf /tmp/*

ARG VCS_REF
ARG CREATED
ARG VERSION=$PHP_VERSION
LABEL org.opencontainers.image.revision=$VCS_REF
LABEL org.opencontainers.image.version=$VERSION
LABEL org.opencontainers.image.created=$CREATED
LABEL org.opencontainers.image.title=php74-fpm
LABEL org.opencontainers.image.description="A PHP 8.0 based base image"
LABEL org.opencontainers.image.url=https://github.com/Ilyes512/docker-php80-fpm
LABEL org.opencontainers.image.documentation=https://github.com/Ilyes512/docker-php80-fpm/blob/master/README.md
LABEL org.opencontainers.image.vendor="ilyes512"
LABEL org.opencontainers.image.licenses=MIT
LABEL org.opencontainers.image.source=https://github.com/Ilyes512/docker-php80-fpm
