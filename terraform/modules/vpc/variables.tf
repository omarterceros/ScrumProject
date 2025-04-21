variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

variable "environment" {
  description = "Environment (develop or production)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}