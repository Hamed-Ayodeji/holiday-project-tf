# create a load balancer to control the traffic to the private instances

resource "aws_lb" "lb" {
  name = "${var.project_name}-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [var.lb_sg_id]
  subnets = [var.private_subnet_ids[0], var.private_subnet_ids[1]]

  tags = {
    Name = "${var.project_name}-lb"
  }
}

##################################################################################

# create a target group for the load balancer

resource "aws_lb_target_group" "tg" {
  name = "${var.project_name}-tg"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = var.vpc_id

  health_check {
    enabled = true
    path = "/"
    port = "80"
    protocol = "HTTP"
    timeout = 60
    interval = 300
    healthy_threshold = 5
    unhealthy_threshold = 5
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

##################################################################################

# create target group attachment for the load balancer

resource "aws_lb_target_group_attachment" "tg_attachment" {
  count = length(var.private_instance_ids)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = var.private_instance_ids[count.index]
  port = 80
}

##################################################################################

# create a listener for the load balancer

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type = "forward"
  }
}