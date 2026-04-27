FROM php:8.3-fpm-bookworm

LABEL org.opencontainers.image.title="HK2 Magento PHP 8.3 FPM" \
      org.opencontainers.image.description="PHP 8.3 FPM environment optimized for Magento 2" \
      org.opencontainers.image.source="https://github.com/basantmandal/docker-magento2-php83" \
      org.opencontainers.image.version="2.0" \
      org.opencontainers.image.authors="Basant Mandal" \
      org.opencontainers.image.url="https://github.com/basantmandal/docker-magento2-php83" \
      org.opencontainers.image.documentation="https://github.com/basantmandal/docker-magento2-php83#readme" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.created="2026-04-27T00:00:00Z" \
      org.opencontainers.image.revision="git-commit-sha"

USER root

# -----------------------------
# Environment Variables
# -----------------------------
ENV TZ=Asia/Kolkata \
    PHP_MEMORY_LIMIT=2048M \
    PHP_MAX_EXECUTION_TIME=60 \
    PHP_UPLOAD_MAX_FILESIZE=50M \
    PHP_POST_MAX_SIZE=50M

ARG CUSTOM_PHP_VERSION=8.3
ARG INSTALL_XDEBUG=false

# -----------------------------
# System Dependencies
# -----------------------------
RUN apt-get update && apt-get install -y \
    build-essential \
    cron \
    curl \
    git \
    iputils-ping \
    jpegoptim optipng pngquant gifsicle \
    libbz2-dev \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    default-libmysqlclient-dev \
    libpng-dev \
    libsodium-dev \
    libsqlite3-dev \
    libwebp-dev \
    libxml2-dev \
    libxpm-dev \
    libxslt1-dev \
    libzip-dev \
    locales \
    sendmail \
    sqlite3 \
    unzip \
    zip \
    zlib1g-dev \
    msmtp \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------
# Composer (v2 required)
# -----------------------------
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# -----------------------------
# PHP Extensions
# -----------------------------
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    calendar \
    curl \
    exif \
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
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "aarch64" ]; then \
    curl -fsSL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_aarch64.tar.gz -o /tmp/ioncube.tar.gz; \
    else \
    curl -fsSL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -o /tmp/ioncube.tar.gz; \
    fi \
    && tar xzf /tmp/ioncube.tar.gz -C /usr/local \
    && echo "zend_extension=ioncube_loader_lin_${CUSTOM_PHP_VERSION}.so" \
    > /usr/local/etc/php/conf.d/ioncube.ini \
    && rm -rf /tmp/ioncube*

# -----------------------------
# PHP Configuration
# -----------------------------
RUN echo "memory_limit=${PHP_MEMORY_LIMIT}" > /usr/local/etc/php/conf.d/zz-custom.ini \
    && echo "upload_max_filesize=${PHP_UPLOAD_MAX_FILESIZE}" >> /usr/local/etc/php/conf.d/zz-custom.ini \
    && echo "post_max_size=${PHP_POST_MAX_SIZE}" >> /usr/local/etc/php/conf.d/zz-custom.ini \
    && echo "max_execution_time=${PHP_MAX_EXECUTION_TIME}" >> /usr/local/etc/php/conf.d/zz-custom.ini \
    && echo "date.timezone=${TZ}" >> /usr/local/etc/php/conf.d/zz-custom.ini \
    && echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/zz-custom.ini \
    && echo "opcache.validate_timestamps=0" >> /usr/local/etc/php/conf.d/zz-custom.ini \
    && echo "opcache.memory_consumption=512" >> /usr/local/etc/php/conf.d/zz-custom.ini

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
# User Setup
# -----------------------------
ARG USER=docker

RUN groupadd --gid 1000 ${USER} \
    && useradd --uid 1000 --gid ${USER} --shell /bin/bash --create-home ${USER}

RUN chown -R ${USER}:www-data /var/www/html

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