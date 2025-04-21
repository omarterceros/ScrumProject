output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "The IDs of the public subnets"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "The IDs of the private subnets"
}

output "web_security_group_id" {
  value       = aws_security_group.web.id
  description = "The ID of the web security group"
}

output "database_security_group_id" {
  value       = aws_security_group.database.id
  description = "The ID of the database security group"
}