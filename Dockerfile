FROM dunglas/frankenphp:latest

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# PHP Extensions required for Laravel 11.x
RUN install-php-extensions \
    pcntl \
    bcmath \
    ctype \
    fileinfo \
    json \
    mbstring \
    openssl \
    pdo \
    tokenizer \
    xml

RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy the application source code
COPY . /var/www/html

WORKDIR /var/www/html

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && mkdir -p /var/www/html/storage \
    && chmod -R 755 /var/www/html/storage \
    && mkdir -p /var/www/html/vendor \
    && chmod -R 755 /var/www/html/vendor


RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

RUN composer install --no-interaction

# Check if vendor/autoload.php exists
RUN ls -al vendor

RUN php artisan key:generate

RUN php artisan optimize

# Expor a porta padrão do FrankenPHP
EXPOSE 80

# Iniciar o servidor FrankenPHP
CMD ["frankenphp", "serve", "--config=/var/www/html/frankenphp.yaml"]