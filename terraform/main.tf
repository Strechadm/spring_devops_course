terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" 
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}

# Створення VPC
module "my_vpc" {
  source = "./modules/vpc"
  vpc_cidr_block       = "10.0.0.0/16"
  vpc_name             = "my-app-vpc"
  environment          = "dev"
  enable_dns_support   = true
  enable_dns_hostnames = true
}


# Створення підмереж
module "my_subnets" {
  source = "./modules/subnets"
  vpc_id                = module.my_vpc.vpc_id
  vpc_name              = module.my_vpc.vpc_name
  subnet_cidr_blocks    = ["10.0.1.0/24", "10.0.2.0/24"]
  subnet_names          = ["public-subnet-1", "private-subnet-1"]
  availability_zones    = ["us-east-1a", "us-east-1b"] # Обов'язково вкажіть свої AZ
  environment           = "dev"
}

# Створення EC2-інстансу
module "my_ec2_instance" {
  source = "./modules/ec2"

  ami_id                    = "ami-000ec6c25978d5999" # Змініть на актуальний AMI ID для вашого регіону (наприклад, Amazon Linux 2 AMI)
  instance_type             = "t2.micro"
  subnet_id                 = module.my_subnets.subnet_ids["public-subnet-1"] # Використовуємо публічну підмережу
  instance_name             = "my-web-server"
  associate_public_ip_address = true
  environment               = "dev"
}
