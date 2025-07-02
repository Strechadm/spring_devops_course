resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address

  tags = {
    Name = var.instance_name
    Environment = var.environment
  }
}