# 1. VPC
resource "aws_vpc" "main" { # terraformda herhangi bir kaynağı yaratmak istiyorsak resource ile yaratıyoruz. vpc yaratma 
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { # iacte tagleme oldukça önemli ve yapılmalı, yaratılan kaynakların görülmesi ve raporlanması için 
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

# 2. Internet Gateway
resource "aws_internet_gateway" "main" { #internete çıkmak için 
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw" # proje adı igw
  }
}

# 3. Subnets (Demonstrating List and Count)
resource "aws_subnet" "public" { 
  count                   = length(var.availability_zones) 
  vpc_id                  = aws_vpc.main.id # referanslar böyle olmalı
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

# 4. Route Table
resource "aws_route_table" "public" { # route table oluşturma subnetlerin internete çıkma kuralları için
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"                  #internet 
    gateway_id = aws_internet_gateway.main.id #internete çıkarken bu gateway'i kullan
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" { #subnet ile route table bağlama
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# 5. Security Group (Demonstrating Set and Dynamic Blocks)
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" { # herhangi bir yerden ec2 bağlanma
    for_each = var.allowed_ports
    content { 
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress { #internete çıkış portları, her porttan veya protokolden internete çıkabilir
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}

# 6. Data Source for AMI
data "aws_ami" "amazon_linux" { # var olan herhangi bir kaynağı ise data ile okuyoruz, var olan ami referansları kullanma, ami = amazon linux 
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# 7. EC2 Instance
resource "aws_instance" "web_server" {   ### user_data, makine ayağa kalktığında bunları yap der ve listeler
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[0].id # Place in the first subnet
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "${var.project_name}-web-server"
  }
}

# reelfiyat için Docker imaj deposu
resource "aws_ecr_repository" "reelfiyat_repo" {
  name                 = "reelfiyat-app"
  image_tag_mutability = "MUTABLE" # İmaj etiketlerinin (örn: latest) güncellenebilmesi için

  image_scanning_configuration {
    scan_on_push = true # İmajı yüklediğimizde güvenlik açıklarını otomatik tara
  }

  tags = {
    Name        = "${var.project_name}-ecr"
    Environment = var.environment
  }
}

# Çıktı olarak ECR URL'ini alalım
output "ecr_repository_url" {
  value = aws_ecr_repository.reelfiyat_repo.repository_url
}