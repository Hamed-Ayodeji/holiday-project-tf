data "aws_ebs_snapshot" "snapshot" {
  most_recent = true
  owners      = ["self"]
}