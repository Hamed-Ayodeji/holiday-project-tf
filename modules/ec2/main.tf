# create a key pair

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "key" {
  key_name = var.project_name
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "private_key" {
  content = tls_private_key.key.private_key_pem
  filename = "${var.project_name}.pem"
  file_permission = "0400"
}

##################################################################################

# create a bastion public ec2 instance for ansible

resource "aws_instance" "bastion" {
  ami = data.aws_ami.focal.id
  instance_type = var.instance_type
  key_name = aws_key_pair.key.key_name
  vpc_security_group_ids = [var.bastion_id]
  subnet_id = var.public_subnet_id
  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "${var.project_name}-bastion"
  }

  depends_on = [ aws_instance.private ]
}

##################################################################################

# create 2 private ec2 instances in each private subnet

resource "aws_instance" "private" {
  count = 2
  ami = data.aws_ami.focal.id
  instance_type = var.instance_type
  key_name = aws_key_pair.key.key_name
  vpc_security_group_ids = [var.private_sg_id]
  subnet_id = element(var.private_subnet_ids, count.index)

  provisioner "local-exec" {
    command = "echo ${aws_instance.private.*.private_ip[count.index]} > ${path.module}/../../../ansible/inventory.ini"
  }

  tags = {
    Name = "${var.project_name}-private-${count.index}"
  }
}

##################################################################################