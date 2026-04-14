output "vpc_id" { 
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "web_server_public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web_server.public_ip
}

output "web_server_url" {
  description = "URL to access the web server"
  value       = "http://${aws_instance.web_server.public_ip}"
}

#  ECR URL output
output "ecr_repository_url" {
  value = aws_ecr_repository.reelfiyat_repo.repository_url
}

# yarattıktan sonra gelen output dosyası