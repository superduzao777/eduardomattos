# Use a imagem base com PHP e as dependências necessárias
FROM dunglas/frankenphp:latest

# Instale dependências do sistema
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Instale o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instale as extensões PHP necessárias
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip

# Configure o diretório de trabalho
WORKDIR /var/www/html

# Copie o composer.lock e o composer.json
COPY composer.lock composer.json ./

# Instale as dependências do Composer
RUN composer install --no-autoloader --no-scripts

# Copie o restante do código da aplicação
COPY . .

# Gere o autoload e execute os scripts do Composer
RUN composer dump-autoload --optimize \
    && composer run-script post-root-package-install \
    && composer run-script post-create-project-cmd

# Ajuste as permissões dos diretórios
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database

# Exponha a porta que o FrankenPHP usa
EXPOSE 80

# Defina o comando de entrada para o FrankenPHP
CMD ["frankenphp", "start"]
