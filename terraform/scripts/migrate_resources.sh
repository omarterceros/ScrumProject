#!/bin/bash

# Script para migrar recursos existentes a la nueva configuración
# Este script ayuda a evitar la recreación de recursos críticos como bases de datos

cd ../environments/develop

# Importar base de datos existente
echo "Importando base de datos RDS existente..."
terraform import module.scrumproject.module.rds.aws_db_instance.main scrumproject-develop-db

# Importar grupo de subredes
echo "Importando grupo de subredes de base de datos..."
terraform import module.scrumproject.module.rds.aws_db_subnet_group.main scrumproject-develop-db-subnet-group

# Aplicar cambios con precaución
echo "Aplicando cambios con la opción '-refresh-only'..."
terraform apply -refresh-only

echo "Ahora ejecuta 'terraform plan' para verificar los cambios pendientes"
echo "Revisa cuidadosamente antes de ejecutar 'terraform apply'"#!/bin/bash

# Script para migrar recursos existentes a la nueva configuración
# Este script ayuda a evitar la recreación de recursos críticos como bases de datos

cd ../environments/develop

# Importar base de datos existente
echo "Importando base de datos RDS existente..."
terraform import module.scrumproject.module.rds.aws_db_instance.main scrumproject-develop-db

# Importar grupo de subredes
echo "Importando grupo de subredes de base de datos..."
terraform import module.scrumproject.module.rds.aws_db_subnet_group.main scrumproject-develop-db-subnet-group

# Aplicar cambios con precaución
echo "Aplicando cambios con la opción '-refresh-only'..."
terraform apply -refresh-only

echo "Ahora ejecuta 'terraform plan' para verificar los cambios pendientes"
echo "Revisa cuidadosamente antes de ejecutar 'terraform apply'"
