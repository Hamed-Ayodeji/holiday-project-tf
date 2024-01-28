output "private_ips" {
  description = "Private IP addresses of the EC2 instances"
  value       = module.ec2.private_ips
}

output "lb_dns_name" {
  description = "DNS name of the load balancer"
  value       = module.lb.lb_dns_name  
}