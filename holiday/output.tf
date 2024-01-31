output "private_ips" {
  description = "Private IP addresses of the EC2 instances"
  value       = module.ec2.private_ips
}