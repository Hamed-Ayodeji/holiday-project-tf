# create a security group for instances in the public subnet

resource "aws_security_group" "bastion" {
  name = "${var.project_name}-public-sg"
  description = "allow ssh, http, https, and icmp traffic inbound traffic from anywhere and all outbound traffic"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################################################################################

# create a security group for instances in the private subnet

resource "aws_security_group" "private_sg" {
  name = "${var.project_name}-private-sg"
  description = "allow ssh, and icmp traffic inbound from bastion security group, http traffic inbound from the lobalancer security group, and all outbound traffics"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################################################################################

# create a security group for the load balancer

resource "aws_security_group" "lb_sg" {
  name = "${var.project_name}-lb-sg"
  description = "allow http and https traffic inbound traffic from anywhere and all outbound traffic"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################################################################################