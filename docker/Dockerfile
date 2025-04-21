FROM php:8.1-fpm

# Argumentos definidos en docker-compose.yml
ARG user
ARG uid

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    zip \
    unzip \
    supervisor \
    nginx

# Limpiar cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar extensiones PHP
RUN docker-php-ext-install pdo pdo_pgsql pgsql mbstring exif pcntl bcmath gd

# Obtener Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crear usuario del sistema para ejecutar comandos Composer y Artisan
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Configurar Nginx
COPY ./docker/nginx.conf /etc/nginx/sites-available/default
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Configurar Supervisor
COPY ./docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Establecer directorio de trabajo
WORKDIR /var/www

# Copiar scripts de inicio
COPY ./docker/start.sh /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

EXPOSE 80

# Iniciar servicios
ENTRYPOINT ["start-container"]