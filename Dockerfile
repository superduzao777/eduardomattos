FROM dunglas/frankenphp:latest-builder AS builder

# Copy xcaddy in the builder image
COPY --from=caddy:builder /usr/bin/xcaddy /usr/bin/xcaddy

# CGO must be enabled to build FrankenPHP
ENV CGO_ENABLED=1 XCADDY_SETCAP=1 XCADDY_GO_BUILD_FLAGS="-ldflags '-w -s'"
RUN xcaddy build \
	--output /usr/local/bin/frankenphp \
	--with github.com/dunglas/frankenphp=./ \
	--with github.com/dunglas/frankenphp/caddy=./caddy/ \
    --with github.com/dunglas/caddy-cbrotli \
    --with github.com/abiosoft/caddy-exec \
    --with github.com/baldinof/caddy-supervisor

FROM dunglas/frankenphp AS runner

RUN apt update && apt install -y htop && \
    apt clean && rm -rf /var/lib/apt/lists/*

# install laravel necessary php extensions \
RUN install-php-extensions pdo_mysql pcntl intl redis opcache

ENV SERVER_NAME=:80

COPY --chown=www-data . /app

WORKDIR /app

#COPY Caddyfile /etc/caddy/Caddyfile
COPY octane.Caddyfile /etc/caddy/Caddyfile

# Replace the official binary by the one contained your custom modules
COPY --from=builder /usr/local/bin/frankenphp /usr/local/bin/frankenphp

ENTRYPOINT ["php", "artisan", "octane:start", "--server=frankenphp", "--port=80", "--admin-port=2089", "--caddyfile=/etc/caddy/Caddyfile", "--workers=20"]
