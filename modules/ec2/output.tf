output "private_instance_ids" {
  value = aws_instance.private[*].id
}