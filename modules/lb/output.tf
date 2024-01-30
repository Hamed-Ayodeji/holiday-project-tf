output "lb_dns_name" {
  value = aws_lb.lb.dns_name
}

output "lb_zone_id" {
  value = aws_lb.lb.zone_id
}

output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}