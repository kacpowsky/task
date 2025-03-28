FROM php:8.1-fpm-alpine

RUN apk add --no-cache \
    postgresql-dev \
    git \
    zip \
    unzip

RUN docker-php-ext-install pdo_pgsql sockets

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY --from=ghcr.io/roadrunner-server/roadrunner:2.12.3 /usr/bin/rr /usr/local/bin/rr

WORKDIR /app

COPY composer.json composer.lock ./

RUN composer update --no-scripts --no-autoloader
RUN composer install --no-scripts --no-autoloader

COPY . .

RUN composer dump-autoload --optimize

RUN chmod +x /usr/local/bin/rr

EXPOSE 8080

CMD ["rr", "serve"]