#!/bin/bash

# Script para configurar el entorno de Terraform

# Verificar que se proporcione un entorno
if [ "$1" != "develop" ] && [ "$1" != "production" ]; then
  echo "Uso: $0 [develop|production]"
  exit 1
fi

ENV=$1
REGION="us-east-1"
STATE_BUCKET="scrumproject-terraform-states"

# Verificar si el bucket de estado de Terraform existe, si no, crearlo
aws s3api head-bucket --bucket $STATE_BUCKET 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Creando bucket de estado de Terraform: $STATE_BUCKET"
  aws s3 mb s3://$STATE_BUCKET --region $REGION
  
  # Habilitar versionamiento del bucket
  aws s3api put-bucket-versioning --bucket $STATE_BUCKET --versioning-configuration Status=Enabled --region $REGION
  
  # Opcional: Habilitar encriptación del bucket
  aws s3api put-bucket-encryption --bucket $STATE_BUCKET --server-side-encryption-configuration '{
    "Rules": [
      {
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }
    ]
  }' --region $REGION
  
  echo "Bucket de estado de Terraform creado y configurado"
fi

# Crear par de claves SSH si no existe
KEY_NAME="scrumproject-$ENV-key"
KEY_FILE="$KEY_NAME.pem"

if ! aws ec2 describe-key-pairs --key-names $KEY_NAME --region $REGION &>/dev/null; then
  echo "Creando par de claves SSH: $KEY_NAME"
  aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text --region $REGION > $KEY_FILE
  chmod 400 $KEY_FILE
  echo "Par de claves SSH creado y guardado en $KEY_FILE"
else
  echo "El par de claves SSH $KEY_NAME ya existe"
fi

# Inicializar Terraform para el entorno específico
echo "Inicializando Terraform para el entorno $ENV"
cd ../environments/$ENV
terraform init

echo "Configuración completada para el entorno $ENV"