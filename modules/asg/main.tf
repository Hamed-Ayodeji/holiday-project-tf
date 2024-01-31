# create an autoscaling group

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.project_name}-asg"
  vpc_zone_identifier       = var.private_subnet_ids
  min_size                  = 2
  max_size                  = 6
  desired_capacity          = 2
  health_check_type         = "EC2"
  health_check_grace_period = 300
  launch_configuration      = aws_launch_configuration.lc.name
  target_group_arns         = [var.target_group_arn]

  tag {
    key                     = var.project_name
    value                   = "${var.project_name}-asg"
    propagate_at_launch     = true
  }
}

##################################################################################

# create a launch configuration

resource "aws_launch_configuration" "lc" {
  name                      = "${var.project_name}-lc"
  image_id                  = var.ami_id
  instance_type             = var.instance_type
  security_groups           = [var.private_sg_id]
  key_name                  = var.key_name

  lifecycle {
    create_before_destroy   = true
  }
}

##################################################################################