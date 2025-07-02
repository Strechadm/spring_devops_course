resource "aws_subnet" "main" {
  for_each          = { for idx, cidr in var.subnet_cidr_blocks : idx => cidr }
  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]

  tags = {
    Name = "${var.subnet_names[each.key]}-${var.environment}"
    Environment = var.environment
  }
}
