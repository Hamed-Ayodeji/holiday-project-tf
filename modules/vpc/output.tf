output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet1_id" {
  value = aws_subnet.private_subnets["private_subnet1"].id
}

output "private_subnet2_id" {
  value = aws_subnet.private_subnets["private_subnet2"].id
}

output "project_name" {
  value = var.project_name
}