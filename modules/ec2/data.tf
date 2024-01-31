data "aws_ami" "focal" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name      = "name"
    values    = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name      = "virtualization-type"
    values    = ["hvm"]
  }
  filter {
    name      = "root-device-type"
    values    = ["ebs"]
  }
  filter {
    name      = "architecture"
    values    = ["x86_64"]
  }
}