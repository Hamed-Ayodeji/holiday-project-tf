# create a key pair

resource "tls_private_key" "key" {
  algorithm               = "RSA"
  rsa_bits                = 4096
}

resource "aws_key_pair" "key" {
  key_name                = var.project_name
  public_key              = tls_private_key.key.public_key_openssh
}

resource "local_file" "private_key" {
  content                 = tls_private_key.key.private_key_pem
  filename                = "${var.project_name}.pem"
  file_permission         = "0400"
}

##################################################################################

# create a bastion public ec2 instance for ansible

resource "aws_instance" "bastion" {
  ami                     = data.aws_ami.focal.id
  instance_type           = var.instance_type
  key_name                = aws_key_pair.key.key_name
  vpc_security_group_ids  = [var.bastion_id]
  subnet_id               = var.public_subnet_ids[0]
  user_data               = file("${path.module}/userdata.sh")

  provisioner "file" {
    source                = "${path.module}/../../holiday/holiday.pem"
    destination           = "/home/ubuntu/holiday.pem"

    connection {
      type                = "ssh"
      user                = "ubuntu"
      private_key         = file("${path.module}/../../holiday/holiday.pem")
      host                = self.public_ip
    }
  }

  provisioner "file" {
    source                = "${path.module}/../../ansible/inventory.ini"
    destination           = "/home/ubuntu/inventory.ini"

    connection {
      type                = "ssh"
      user                = "ubuntu"
      private_key         = file("${path.module}/../../holiday/holiday.pem")
      host                = self.public_ip
    }
  }

  tags                    = {
    Name                  = "${var.project_name}-bastion"
  }

  depends_on              = [aws_instance.private, local_file.private_key, local_file.private_ips]
}

##################################################################################

# create 2 private ec2 instances in each private subnet

resource "aws_instance" "private" {
  count                   = 2
  ami                     = data.aws_ami.focal.id
  instance_type           = var.instance_type
  key_name                = aws_key_pair.key.key_name
  vpc_security_group_ids  = [var.private_sg_id]
  subnet_id               = element(var.private_subnet_ids, count.index)

  tags                    = {
    Name                  = "${var.project_name}-private-${count.index}"
  }
}

##################################################################################

# create a local-exec provisioner to generate the inventory file

locals {
  private_ips             = aws_instance.private[*].private_ip
}

resource "local_file" "private_ips" {
  content                 = join("\n", local.private_ips)
  filename                = "${path.module}/../../ansible/inventory.ini"
  
  depends_on              = [aws_instance.private]
}

##################################################################################