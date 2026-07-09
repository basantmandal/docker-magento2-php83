FROM php:8.3-fpm-bookworm

LABEL org.opencontainers.image.title="HK2 Magento PHP 8.3 FPM" \
      org.opencontainers.image.description="PHP 8.3 FPM environment optimized for Magento 2" \
      org.opencontainers.image.source="https://github.com/basantmandal/docker-magento2-php83" \
      org.opencontainers.image.version="2.4.1" \
      org.opencontainers.image.authors="Basant Mandal" \
      org.opencontainers.image.url="https://github.com/basantmandal/docker-magento2-php83" \
      org.opencontainers.image.documentation="https://github.com/basantmandal/docker-magento2-php83#readme" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.created="2026-07-09T00:00:00Z" \
      org.opencontainers.image.revision="git-commit-sha"

USER root

# -----------------------------
# Environment Variables
# -----------------------------
ENV TZ=Asia/Kolkata \
    PHP_MEMORY_LIMIT=4096M \
    PHP_MAX_EXECUTION_TIME=60 \
    PHP_UPLOAD_MAX_FILESIZE=50M \
    PHP_POST_MAX_SIZE=50M

ARG CUSTOM_PHP_VERSION=8.3
ARG INSTALL_XDEBUG=false

# -----------------------------
# System Dependencies
# -----------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cron \
    curl \
    git \
    iputils-ping \
    unzip zip \
    locales \
    msmtp \
    sendmail \
    sqlite3 \
    libonig-dev \
    libicu-dev \
    libzip-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libwebp-dev \
    libxpm-dev \
    libxslt1-dev \
    libbz2-dev \
    libsqlite3-dev \
    libxml2-utils \
    zlib1g-dev \
    default-libmysqlclient-dev \
    jpegoptim optipng pngquant gifsicle \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------
# Composer (v2 required)
# -----------------------------
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# -----------------------------
# PHP Extensions
# -----------------------------
RUN set -eux; \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
    docker-php-ext-install -j1 \
        bcmath \
        calendar \
        curl \
        exif \
        ftp \
        gd \
        intl \
        mysqli \
        opcache \
        pdo_mysql \
        pdo_sqlite \
        soap \
        sockets \
        xsl \
        zip

# -----------------------------
# Redis Extension (PHP 8.3 compatible)
# -----------------------------
RUN pecl install redis \
    && docker-php-ext-enable redis

# -----------------------------
# Optional Xdebug (v3)
# -----------------------------
RUN if [ "$INSTALL_XDEBUG" = "true" ]; then \
    pecl install xdebug && docker-php-ext-enable xdebug ; \
    fi

# -----------------------------
# IonCube Loader (PHP 8.3)
# -----------------------------
RUN set -eux; \
    ARCH="$(uname -m)"; \
    case "$ARCH" in \
        aarch64|arm64) \
            URL="https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_aarch64.tar.gz" ;; \
        x86_64|amd64) \
            URL="https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz" ;; \
        *) \
            echo "Unsupported architecture: $ARCH"; \
            exit 1 ;; \
    esac; \
    \
    curl -fsSL "$URL" -o /tmp/ioncube.tar.gz || exit 0; \
    tar -xzf /tmp/ioncube.tar.gz -C /usr/local || exit 0; \
    \
    EXT_DIR="$(php-config --extension-dir)"; \
    LOADER_FILE="$(find /usr/local/ioncube -name "ioncube_loader_lin_8.3.so" | head -n 1)"; \
    \
    if [ -f "$LOADER_FILE" ]; then \
        cp "$LOADER_FILE" "$EXT_DIR/"; \
        echo "zend_extension=${EXT_DIR}/ioncube_loader_lin_8.3.so" \
            > /usr/local/etc/php/conf.d/00-ioncube.ini; \
        php -m | grep -i ionCube; \
    else \
        echo "IonCube loader not available for $ARCH"; \
    fi; \
    \
    rm -rf /tmp/ioncube*

# -----------------------------
# PHP Configuration
# -----------------------------
RUN set -eux; \
    mkdir -p /usr/local/etc/php/conf.d/defaults; \
    { \
      echo "memory_limit=${PHP_MEMORY_LIMIT}"; \
      echo "upload_max_filesize=${PHP_UPLOAD_MAX_FILESIZE}"; \
      echo "post_max_size=${PHP_POST_MAX_SIZE}"; \
      echo "max_execution_time=${PHP_MAX_EXECUTION_TIME}"; \
      echo "date.timezone=${TZ:-Asia/Kolkata}"; \
      echo "opcache.enable=1"; \
      echo "opcache.validate_timestamps=1"; \
      echo "opcache.revalidate_freq=0"; \
      echo "opcache.memory_consumption=512"; \
    } > /usr/local/etc/php/conf.d/10-default.ini

# -----------------------------
# MSMTP
# -----------------------------
COPY msmtp.conf /etc/msmtprc

RUN chmod 600 /etc/msmtprc \
    && chown root:root /etc/msmtprc \
    && ln -sf /usr/bin/msmtp /usr/sbin/sendmail \
    && echo "sendmail_path=/usr/bin/msmtp -t -i" > /usr/local/etc/php/conf.d/sendmail.ini \
    && touch /var/log/msmtp.log \
    && chmod 666 /var/log/msmtp.log

# -----------------------------
# Locale
# -----------------------------
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# -----------------------------
# PHP-FPM Performance Tuning
# -----------------------------
RUN set -eux; \
    { \
      echo "[www]"; \
      echo "pm = dynamic"; \
      echo "pm.max_children = 20"; \
      echo "pm.start_servers = 4"; \
      echo "pm.min_spare_servers = 2"; \
      echo "pm.max_spare_servers = 6"; \
    } > /usr/local/etc/php-fpm.d/zz-performance.conf

# -----------------------------
# User Setup
# -----------------------------
ARG USER=docker

RUN groupadd -g 1000 ${USER} \
    && useradd -m -u 1000 -g ${USER} -s /bin/bash ${USER} \
    && chown -R ${USER}:www-data /var/www

USER ${USER}

# -----------------------------
# Composer Setup
# -----------------------------
RUN mkdir -p /home/${USER}/.composer \
    && echo "{}" > /home/${USER}/.composer/auth.json \
    && mkdir -p /home/${USER}/.composer/vendor/bin

ENV PATH="/home/${USER}/.composer/vendor/bin:${PATH}"

# -----------------------------
# Working Directory
# -----------------------------
WORKDIR /var/www/html
