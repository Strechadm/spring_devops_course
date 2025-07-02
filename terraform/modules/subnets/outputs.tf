output "subnet_ids" {
  description = "A map of subnet names to their IDs."
  # value       = { for name, subnet in aws_subnet.main : name => subnet.id }
  value = {
    for idx, subnet in aws_subnet.main :
    var.subnet_names[idx] => subnet.id
  }
}
