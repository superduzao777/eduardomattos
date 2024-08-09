# Use the official FrankenPHP image as a base image
FROM dunglas/frankenphp:latest

# Set environment variables
ENV APP_ENV=production
ENV APP_DEBUG=false

# Install system dependencies
RUN apk update && apk add --no-cache \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    freetype-dev \
    libzip-dev \
    unzip \
    git \
    oniguruma-dev \
    icu-dev \
    bash \
    # Add any other dependencies your application might need
    && apk add --no-cache --virtual .build-deps \
    build-base \
    && apk add --no-cache \
    libxml2-dev \
    && apk del .build-deps

# Install PHP extensions
RUN apk add --no-cache php8-gd php8-intl php8-mysqli php8-pdo php8-pdo_mysql php8-zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application code
COPY . /var/www/html

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy .env.example to .env (Laravel requires .env)
RUN cp .env.example .env

# Generate application key (Laravel requires an app key)
RUN php artisan key:generate

# Expose port 8080 for FrankenPHP
EXPOSE 8080

# Start FrankenPHP
CMD ["frankenphp", "artisan", "octane:start", "--host=0.0.0.0", "--port=8080"]
