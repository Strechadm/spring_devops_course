
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