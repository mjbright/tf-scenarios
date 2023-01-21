
# Data source to get latest Ubuntu 20.04 LTS:

data "aws_ami" "latest_ubuntu_lts_2004" {
  owners = [ var.ami_account ]

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source to get latest Ubuntu 18.04 LTS:

data "aws_ami" "latest_ubuntu_lts_1804" {
  owners = [ var.ami_account ]

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



