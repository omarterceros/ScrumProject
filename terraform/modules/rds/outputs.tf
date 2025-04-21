output "db_instance_address" {
  value       = aws_db_instance.postgres.address
  description = "The address of the RDS instance"
}

output "db_instance_endpoint" {
  value       = aws_db_instance.postgres.endpoint
  description = "The connection endpoint of the RDS instance"
}

output "db_instance_name" {
  value       = aws_db_instance.postgres.db_name
  description = "The name of the database"
}

output "db_instance_username" {
  value       = aws_db_instance.postgres.username
  description = "The master username for the database"
  sensitive   = true
}

output "db_instance_port" {
  value       = aws_db_instance.postgres.port
  description = "The database port"
}