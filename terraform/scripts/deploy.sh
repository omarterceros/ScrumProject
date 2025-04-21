#!/bin/bash
set -e

# Variables
ENVIRONMENT=$1
SSH_KEY=$2
EC2_USER=$3
EC2_HOST=$4

# Validar parámetros
if [ -z "$ENVIRONMENT" ] || [ -z "$SSH_KEY" ] || [ -z "$EC2_USER" ] || [ -z "$EC2_HOST" ]; then
    echo "Uso: $0 <environment> <ssh_key_path> <ec2_user> <ec2_host>"
    echo "Ejemplo: $0 develop ~/.ssh/id_rsa ec2-user ec2-xx-xx-xx-xx.compute-1.amazonaws.com"
    exit 1
fi

echo "Desplegando en el entorno: $ENVIRONMENT"
echo "Host: $EC2_HOST"

# Desplegar en el servidor
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$EC2_USER@$EC2_HOST" << EOF
    cd /var/www/scrumproject
    git pull origin $ENVIRONMENT
    composer install --no-interaction --prefer-dist --optimize-autoloader
    php artisan migrate --force
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    chmod -R 775 storage bootstrap/cache
EOF

echo "Despliegue completado con éxito"