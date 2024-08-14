# Use a imagem base do FrankenPHP
FROM dunglas/frankenphp:latest

# Definir o diretório de trabalho dentro do contêiner
WORKDIR /var/www/html

# Copiar os arquivos do projeto para o contêiner
COPY . .

# Instalar dependências do sistema necessárias
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo zip

# Instalar o Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instalar as dependências do Laravel via Composer
RUN composer install --optimize-autoloader --no-dev

# Ajustar permissões para o diretório de armazenamento e cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expor a porta padrão do FrankenPHP
EXPOSE 80

# Definir o comando de inicialização do contêiner
CMD ["frankenphp", "serve", "--config=/var/www/html/frankenphp.yaml"]
