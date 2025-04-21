terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr_block    = var.vpc_cidr_block
  environment       = var.environment
  project_name      = var.project_name
}

module "ec2" {
  source = "./modules/ec2"
  
  vpc_id                  = module.vpc.vpc_id
  subnet_id               = module.vpc.public_subnet_ids[0]
  environment             = var.environment
  project_name            = var.project_name
  instance_type           = var.instance_type
  key_name                = var.key_name
  db_host                 = module.rds.db_instance_address
  db_name                 = var.db_name
  db_username             = var.db_username
  db_password             = var.db_password
  db_port                 = var.db_port
}

module "rds" {
  source = "./modules/rds"
  
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnet_ids
  ec2_security_group_id   = module.ec2.security_group_id
  environment             = var.environment
  project_name            = var.project_name
  db_instance_class       = var.db_instance_class
  db_allocated_storage    = var.db_allocated_storage
  db_name                 = var.db_name
  db_username             = var.db_username
  db_password             = var.db_password
  db_port                 = var.db_port
}

# Salidas
output "ec2_public_ip" {
  value       = module.ec2.public_ip
  description = "The public IP of the EC2 instance"
}

output "rds_endpoint" {
  value       = module.rds.db_instance_address
  description = "The endpoint of the RDS instance"
}