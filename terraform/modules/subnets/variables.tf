variable "vpc_id" {
  description = "The ID of the VPC where subnets will be created."
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC (used for tagging)."
  type        = string
}

variable "subnet_cidr_blocks" {
  description = "A list of CIDR blocks for the subnets."
  type        = list(string)
}

variable "subnet_names" {
  description = "A list of names for the subnets (must match order of cidr_blocks)."
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of availability zones for the subnets (must match order of cidr_blocks)."
  type        = list(string)
}

variable "environment" {
  description = "The environment (e.g., dev, prod, staging)."
  type        = string
  default     = "dev"
}


