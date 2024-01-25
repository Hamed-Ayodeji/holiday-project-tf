output "bastion_id" {
  value = aws_security_group.bastion.id
}

output "private_sg_id" {
  value = aws_security_group.private_sg.id
}

output "lb_sg_id" {
  value = aws_security_group.lb_sg.id
}