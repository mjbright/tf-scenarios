
# Data source to get latest Ubuntu 18.04 LTS:

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"] # Canonical

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

