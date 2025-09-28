output "ec2_public_ip" {
  value       = aws_instance.app_server.public_ip
  description = "Public IP of EC2 instance"
}

output "ecr_webapp_url" {
  value       = aws_ecr_repository.webapp.repository_url
  description = "ECR URL for webapp"
}

output "ecr_mysql_url" {
  value       = aws_ecr_repository.mysqldb.repository_url
  description = "ECR URL for mysqldb"
}