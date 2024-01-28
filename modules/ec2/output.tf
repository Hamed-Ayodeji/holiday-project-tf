output "private_instance_ids" {
  value = aws_instance.private[*].id
}

output "key_name" {
  value = aws_key_pair.key.key_name
}

output "private_ips" {
  value = local.private_ips
}