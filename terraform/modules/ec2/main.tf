data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "web_ec2" {
  name        = "${var.project_name}-${var.environment}-web-ec2-sg"
  description = "Security group for EC2 web servers"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-web-ec2-sg"
    Environment = var.environment
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_ec2.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras enable php8.1
    yum install -y httpd php php-cli php-fpm php-pgsql php-json php-common php-mbstring php-xml php-zip php-gd unzip git

    # Instalar Composer
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
    chmod +x /usr/local/bin/composer

    # Configurar Apache
    systemctl start httpd
    systemctl enable httpd
    usermod -a -G apache ec2-user
    chown -R ec2-user:apache /var/www
    chmod 2775 /var/www
    find /var/www -type d -exec chmod 2775 {} \;
    find /var/www -type f -exec chmod 0664 {} \;
    
    # Crear directorio para la aplicación
    mkdir -p /var/www/scrumproject
    cd /var/www
    
    # Clonar el repositorio (asumiendo que tienes acceso público)
    git clone https://github.com/tuusuario/scrumproject.git
    cd scrumproject
    
    # Instalar dependencias
    composer install --no-interaction --prefer-dist --optimize-autoloader
    
    # Configurar permisos
    chown -R ec2-user:apache /var/www/scrumproject
    chmod -R 775 /var/www/scrumproject/storage
    chmod -R 775 /var/www/scrumproject/bootstrap/cache
    
    # Configurar variables de entorno
    cp .env.example .env
    php artisan key:generate
    
    # Configurar base de datos
    echo "DB_CONNECTION=pgsql" >> .env
    echo "DB_HOST=${var.db_host}" >> .env
    echo "DB_PORT=${var.db_port}" >> .env
    echo "DB_DATABASE=${var.db_name}" >> .env
    echo "DB_USERNAME=${var.db_username}" >> .env
    echo "DB_PASSWORD=${var.db_password}" >> .env
    
    # Ejecutar migraciones
    php artisan migrate --force
    
    # Cachear configuraciones
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache

    # Configurar el virtual host de Apache
    cat > /etc/httpd/conf.d/scrumproject.conf << 'EOL'
    <VirtualHost *:80>
        ServerName ${var.project_name}-${var.environment}
        DocumentRoot /var/www/scrumproject/public
        
        <Directory /var/www/scrumproject/public>
            AllowOverride All
            Require all granted
        </Directory>
        
        ErrorLog /var/log/httpd/scrumproject-error.log
        CustomLog /var/log/httpd/scrumproject-access.log combined
    </VirtualHost>
    EOL
    
    # Reiniciar Apache
    systemctl restart httpd
  EOF

  tags = {
    Name        = "${var.project_name}-${var.environment}-web-server"
    Environment = var.environment
  }
}

resource "aws_eip" "web" {
  vpc = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-web-eip"
    Environment = var.environment
  }
}

resource "aws_eip_association" "web" {
  instance_id   = aws_instance.web.id
  allocation_id = aws_eip.web.id
}