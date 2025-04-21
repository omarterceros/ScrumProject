output "instance_id" {
  value       = aws_instance.web.id
  description = "The ID of the EC2 instance"
}

output "public_ip" {
  value       = aws_eip.web.public_ip
  description = "The public IP of the EC2 instance"
}

output "public_dns" {
  value       = aws_instance.web.public_dns
  description = "The public DNS of the EC2 instance"
}

output "security_group_id" {
  value       = aws_security_group.web_ec2.id
  description = "The ID of the security group"
}