output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.main.address
}

output "db_instance_endpoint" {
  description = "The connection endpoint of the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_id" {
  description = "The ID of the RDS instance"
  value       = aws_db_instance.main.id
}

output "db_subnet_group_id" {
  description = "The ID of DB subnet group"
  value       = aws_db_subnet_group.main.id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.rds.id
}