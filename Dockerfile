# Use a base image with FrankenPHP
FROM dunglas/frankenphp:latest

# Set working directory
WORKDIR /var/www

# Copy application code
COPY . .

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install application dependencies
RUN composer install --no-dev --optimize-autoloader

# Expose the port FrankenPHP will run on
EXPOSE 8080

# Start FrankenPHP
CMD ["frankenphp", "public/index.php"]
