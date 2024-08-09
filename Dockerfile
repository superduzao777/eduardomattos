# Build stage
FROM dunglas/frankenphp:builder-php8.3.10-bookworm AS builder

# Copy xcaddy in the builder image
COPY --from=caddy:builder /usr/bin/xcaddy /usr/bin/xcaddy

# CGO must be enabled to build FrankenPHP
ENV CGO_ENABLED=1 XCADDY_SETCAP=1 XCADDY_GO_BUILD_FLAGS="-ldflags '-w -s'"
RUN xcaddy build \
    --output /usr/local/bin/frankenphp \
    --with github.com/dunglas/frankenphp=./ \
    --with github.com/dunglas/frankenphp/caddy=./caddy/ \
    --with github.com/dunglas/caddy-cbrotli

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Application setup stage
FROM dunglas/frankenphp AS runner

# Install required packages and dependencies for zip extension
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    && docker-php-ext-install zip \
    && apt-get clean

# Install Composer in the runner stage as well (if needed for further usage)
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Set the working directory
WORKDIR /var/www/html

# Copy Laravel application files to the container
COPY . /var/www/html

# Install PHP dependencies using Composer
RUN composer install --no-dev --optimize-autoloader

# Set up storage directories and permissions
RUN mkdir -p /var/www/html/storage \
    && mkdir -p /var/www/html/storage/framework/cache/data \
    && chmod -R 775 /var/www/html/storage \
    && chown -R www-data:www-data /var/www/html/storage

# Ensure the SQLite database file exists and set permissions
RUN touch /var/www/html/database/database.sqlite \
    && chmod 664 /var/www/html/database/database.sqlite \
    && chown www-data:www-data /var/www/html/database/database.sqlite

# Set environment variable for SQLite
ENV DB_CONNECTION=sqlite
ENV DB_DATABASE=/var/www/html/database/database.sqlite

# Replace the official binary by the one containing your custom modules
COPY --from=builder /usr/local/bin/frankenphp /usr/local/bin/frankenphp

# Copy the Caddyfile
COPY Caddyfile /etc/caddy/Caddyfile

# Expose port 8080 and set entrypoint
EXPOSE 8080
CMD ["frankenphp", "--config", "/etc/caddy/Caddyfile"]
