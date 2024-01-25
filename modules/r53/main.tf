# create a hosted zone

resource "aws_route53_zone" "zone" {
  name = var.domain_name

  tags = {
    Name = "${var.project_name}-zone"
  }

  lifecycle {
    create_before_destroy = true
  }
}

##################################################################################

# create an A record for the load balancer

resource "aws_route53_record" "lb" {
  zone_id = aws_route53_zone.zone.zone_id
  name = var.subdomain_name
  type = "A"
  alias {
    name = var.lb_dns_name
    zone_id = var.lb_zone_id
    evaluate_target_health = true
  }

  lifecycle {
    create_before_destroy = true
  }
}