FROM dunglas/frankenphp:1-php8.3-alpine

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    git \
    curl \
    && docker-php-ext-install zip pdo pdo_mysql

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instalar Node.js e npm
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Instalar dependências do Laravel e FrankenPHP
WORKDIR /var/www/html
COPY . .
RUN composer install --optimize-autoloader --no-dev && \
    composer require symfony/runtime && \
    composer require laravel/octane && \
    npm install --production && \
    npm run build

EXPOSE 80

CMD ["php", "artisan", "octane:start", "--server=frankenphp", "--host=0.0.0.0", "--port=8000"]
