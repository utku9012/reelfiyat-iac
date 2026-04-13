terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.23.0"
    }
  }

  backend "s3" { # CI/CD pipelinelar ile çalışılacağı zaman bir back-end gerekir 
    bucket         = "utku-iac" # bucket name
    key            = "terraform.tfstate" # bucket'ın altındaki klasör, path
    region         = "eu-central-1"
  }
}

provider "aws" { # aws provider kullanıldığı için awsinin ayarlarını yapıyoruz
  region = var.aws_region
}

# provider kısmı terraform registryden bulunabilir // terraform aws provider, terraform cloudfare providervs.
