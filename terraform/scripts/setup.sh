#!/bin/bash
set -e

# Variables
ENVIRONMENT=$1

# Validar parámetros
if [ -z "$ENVIRONMENT" ]; then
    echo "Uso: $0 <environment>"
    echo "Ejemplo: $0 develop"
    exit 1
fi

echo "Configurando infraestructura para el entorno: $ENVIRONMENT"

# Crear bucket S3 para almacenar el estado de Terraform (si no existe)
aws s3api create-bucket \
    --bucket scrumproject-terraform-states \
    --region us-west-2 \
    --create-bucket-configuration LocationConstraint=us-west-2

# Habilitar versionamiento en el bucket
aws s3api put-bucket-versioning \
    --bucket scrumproject-terraform-states \
    --versioning-configuration Status=Enabled

# Crear par de claves SSH para EC2 si no existe
KEY_NAME="scrumproject-$ENVIRONMENT-key"
if ! aws ec2 describe-key-pairs --key-names $KEY_NAME --region us-west-2 &> /dev/null; then
    echo "Creando par de claves SSH: $KEY_NAME"
    aws ec2 create-key-pair \
        --key-name $KEY_NAME \
        --query "KeyMaterial" \
        --output text > ~/.ssh/$KEY_NAME.pem
    chmod 400 ~/.ssh/$KEY_NAME.pem
    echo "Par de claves SSH creado y guardado en ~/.ssh/$KEY_NAME.pem"
else
    echo "El par de claves SSH $KEY_NAME ya existe"
fi

# Inicializar Terraform
cd ../environments/$ENVIRONMENT
terraform init

echo "Configuración completada con éxito. Puedes ejecutar 'terraform plan' para ver los cambios planificados."