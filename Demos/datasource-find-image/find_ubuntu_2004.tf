
variable region {
  default = "us-west-1"
}

locals {
  canonical_account_number = "099720109477"
}

provider "aws" {
  region = var.region
}

# Data source to get latest Ubuntu 20.04 LTS:

data "aws_ami" "latest_ubuntu_lts_2004" {
  owners = [ local.canonical_account_number ]

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

output ubuntu2004 {
    value = "Latest Ubuntu 20.04 build in region ${ var.region } has ami='${ data.aws_ami.latest_ubuntu_lts_2004.id }'"
}

