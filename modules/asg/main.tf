# create an autoscaling group

resource "aws_autoscaling_group" "asg" {
  name = "${var.project_name}-asg"
  vpc_zone_identifier = var.private_subnet_ids
  min_size = 2
  max_size = 6
  desired_capacity = 2
  health_check_type = "EC2"
  health_check_grace_period = 300
  launch_configuration = aws_launch_configuration.lc.name
  target_group_arns = [aws_lb_target_group.tg.arn]

  tag {
    key = "Name"
    value = "${var.project_name}-asg"
    propagate_at_launch = true
  }
}

##################################################################################
# create an ami from the snapshot

resource "aws_ami" "from_snapshot" {
  name                = var.snapshot_name
  virtualization_type = "hvm"

  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = data.aws_ebs_snapshot.snapshot.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

##################################################################################

# create a launch configuration

resource "aws_launch_configuration" "lc" {
  name = "${var.project_name}-lc"
  image_id = aws_ami.from_snapshot.id
  instance_type = var.instance_type
  security_groups = [var.private_sg_id]
  key_name = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

##################################################################################