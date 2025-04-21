#!/bin/bash

# Script para desplegar la aplicación en EC2

# Verificar que se proporcione un entorno
if [ "$1" != "develop" ] && [ "$1" != "production" ]; then
  echo "Uso: $0 [develop|production]"
  exit 1
fi

ENV=$1
REGION="us-east-1"
PROJECT_NAME="scrumproject"
KEY_NAME="${PROJECT_NAME}-${ENV}-key"
KEY_FILE="${KEY_NAME}.pem"

# Obtener la IP pública de la instancia EC2 usando Terraform
cd ../environments/$ENV
EC2_PUBLIC_IP=$(terraform output -raw ec2_public_ip)

if [ -z "$EC2_PUBLIC_IP" ]; then
  echo "No se pudo obtener la IP pública de la instancia EC2."
  exit 1
fi

echo "IP pública de la instancia EC2: $EC2_PUBLIC_IP"

# Esperar a que la instancia esté lista
echo "Esperando a que la instancia esté lista..."
sleep 30

# Verificar si existe el archivo de clave
if [ ! -f "$KEY_FILE" ]; then
  echo "Archivo de clave $KEY_FILE no encontrado. Utilizando la configuración de claves SSH existente."
else
  # Asegurar permisos correctos para la clave
  chmod 400 $KEY_FILE
fi

# Implementar la aplicación
echo "Desplegando la aplicación en el entorno $ENV..."

ssh -o StrictHostKeyChecking=no -i $KEY_FILE ec2-user@$EC2_PUBLIC_IP << EOF
  cd /var/www/scrumproject
  git pull origin ${ENV}
  composer install --no-interaction --prefer-dist --optimize-autoloader
  php artisan migrate --force
  php artisan config:cache
  php artisan route:cache
  php artisan view:cache
  echo "Implementación completada en $ENV"
EOF

if [ $? -eq 0 ]; then
  echo "Despliegue completado con éxito en $ENV."
  echo "URL de la aplicación: http://$EC2_PUBLIC_IP"
else
  echo "Error durante el despliegue."
  exit 1
fi