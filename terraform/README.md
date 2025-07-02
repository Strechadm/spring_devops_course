# Advanced Terraform

Цей проєкт демонструє модульну структуру Terraform для створення інфраструктури в AWS, включаючи VPC, підмережі та EC2-інстанси.

## 📁 Структура проєкту

```
.
├── main.tf
├── modules
│   ├── ec2
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── subnets
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
└── variables.tf
```

## 📦 Модулі

### VPC

**`modules/vpc/main.tf`**
- Створює VPC з Internet Gateway.
- Параметри:
  - `cidr_block`
  - `enable_dns_support`
  - `enable_dns_hostnames`
  - теги: `Name`, `Environment`

**`modules/vpc/variables.tf`**
- Змінні для VPC: CIDR, ім’я, підтримка DNS, середовище.

**`modules/vpc/outputs.tf`**
- Експортує: `vpc_id`, `vpc_cidr_block`, `internet_gateway_id`, `vpc_name`.

---

### Subnets

**`modules/subnets/main.tf`**
- Створює підмережі з використанням `for_each`.
- Прив’язує до VPC, AZ та CIDR.

**`modules/subnets/variables.tf`**
- Змінні: `vpc_id`, `subnet_cidr_blocks`, `subnet_names`, `availability_zones`, `environment`.

**`modules/subnets/outputs.tf`**
- Експортує `subnet_ids` у форматі мапи.

---

### EC2

**`modules/ec2/main.tf`**
- Створює EC2 інстанс з параметрами:
  - AMI
  - тип інстансу
  - публічна IP-адреса
  - прив’язка до підмережі

**`modules/ec2/variables.tf`**
- Змінні: `ami_id`, `instance_type`, `subnet_id`, `instance_name`, `associate_public_ip_address`, `environment`.

**`modules/ec2/outputs.tf`**
- Експортує `instance_id`, `public_ip`, `private_ip`.

---

## 🛠 Основний файл `main.tf`

```hcl
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

module "my_vpc" {
  source                = "./modules/vpc"
  vpc_cidr_block        = "10.0.0.0/16"
  vpc_name              = "my-app-vpc"
  environment           = "dev"
  enable_dns_support    = true
  enable_dns_hostnames  = true
}

module "my_subnets" {
  source             = "./modules/subnets"
  vpc_id             = module.my_vpc.vpc_id
  vpc_name           = module.my_vpc.vpc_name
  subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  subnet_names       = ["public-subnet-1", "private-subnet-1"]
  availability_zones = ["us-east-1a", "us-east-1b"]
  environment        = "dev"
}

module "my_ec2_instance" {
  source                     = "./modules/ec2"
  ami_id                     = "ami-000ec6c25978d5999" # Замініть на актуальний
  instance_type              = "t2.micro"
  subnet_id                  = module.my_subnets.subnet_ids["public-subnet-1"]
  instance_name              = "my-web-server"
  associate_public_ip_address = true
  environment                = "dev"
}
```

---

## 📤 Outputs (`outputs.tf`)

```hcl
output "vpc_id" {
  description = "The ID of the main VPC created by the 'my_vpc' module."
  value       = module.my_vpc.vpc_id
}

output "public_subnet_id" {
  value = module.my_subnets.subnet_ids["public-subnet-1"]
}

output "ec2_public_ip" {
  value = module.my_ec2_instance.public_ip
}
```

---

## 🔧 Змінні (`variables.tf`)

```hcl
variable "region" {
  description = "AWS Region where to provision VPC Network"
  default     = "us-east-1"
}
```

---

## 🚀 Команди Terraform

```sh
terraform init
terraform plan
terraform apply
```

---

## 📌 Примітка

- Замініть `ami_id` на актуальний AMI у вашому регіоні (наприклад, Amazon Linux 2).
- Availability Zones повинні відповідати вашому регіону (наприклад, `us-east-1a`, `us-east-1b`).
