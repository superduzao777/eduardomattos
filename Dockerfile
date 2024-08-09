FROM dunglas/frankenphp:1-alpine

# Instala dependências necessárias
RUN apt-get update && \
    apt-get install -y \
    libzip-dev \
    unzip \
    git \
    curl && \
    docker-php-ext-install zip pdo pdo_mysql

# Copia o código da aplicação
COPY . /var/www/html

# Define o diretório de trabalho
WORKDIR /var/www/html

# Define o comando de entrada padrão
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=80"]
