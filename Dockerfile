# Use a imagem base do FrankenPHP
FROM dunglas/frankenphp

# Copiar os arquivos do projeto para o contêiner
COPY . /app

# Instalar dependências do sistema necessárias
RUN install-php-extensions \
	pcntl \
	pdo_mysql \
    pdo_sqlite \
	gd \
	intl \
	zip \
	opcache

# Instalar o Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app
# Instalar as dependências do Laravel via Composer
RUN composer install --optimize-autoloader --no-dev

# Ajustar permissões para o diretório de armazenamento e cache
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache

# Expor a porta padrão do FrankenPHP
EXPOSE 80

ENTRYPOINT ["php", "artisan", "octane:frankenphp"]

