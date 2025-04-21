terraform {
  backend "s3" {
    bucket = "scrumproject-terraform-states"
    key    = "production/terraform.tfstate"
    region = "us-west-2"  # Región donde está el bucket S3
  }
}

module "scrumproject" {
  source = "../../"
  
  aws_region         = var.aws_region
  environment        = var.environment
  project_name       = var.project_name
  vpc_cidr_block     = var.vpc_cidr_block
  
  # EC2
  instance_type      = var.instance_type
  key_name           = var.key_name
  
  # RDS
  db_instance_class  = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  db_port            = var.db_port
}

output "ec2_public_ip" {
  value = module.scrumproject.ec2_public_ip
}

output "rds_endpoint" {
  value = module.scrumproject.rds_endpoint
}