
provider aws { region = var.region }

variable region { default = "us-west-1" }

variable ubuntu_account_number { default = "099720109477" }

data "aws_ami" "latest_x86_64_ubuntu" {
  owners       = ["${var.ubuntu_account_number}"]
  most_recent  = true
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "ubuntu-20_04" {
  most_recent = true
  owners = ["${var.ubuntu_account_number}"]

  filter {
    name   = "name"
    #values = ["ubuntu/images/hvm-ssd/ubuntu-fossa-20.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Too much output:
#data "aws_ami_ids" "ubuntu" {
#  owners = ["${var.ubuntu_account_number}"]
#}
#output ubuntu_images {
#    value = data.aws_ami_ids.ubuntu.ids
#}


output ubuntu_latest {
    #value = "[${data.aws_ami.latest_x86_64_ubuntu.creation_date}] Image ${data.aws_ami.latest_x86_64_ubuntu.id} ${data.aws_ami.latest_x86_64_ubuntu.image_owner_alias} ${data.aws_ami.latest_x86_64_ubuntu.description}"
    #value = "\n\t[${data.aws_ami.latest_x86_64_ubuntu.creation_date}] Image in region ${var.region}: ${data.aws_ami.latest_x86_64_ubuntu.id} ${data.aws_ami.latest_x86_64_ubuntu.description}"
    value = format("\n\t[%s] Image in region %s: %s - '%s'",
        data.aws_ami.latest_x86_64_ubuntu.creation_date, var.region, data.aws_ami.latest_x86_64_ubuntu.id, data.aws_ami.latest_x86_64_ubuntu.description)
}

output ubuntu_2004_lts_latest {
    #value = "[${data.aws_ami.latest_x86_64_ubuntu.creation_date}] Image ${data.aws_ami.latest_x86_64_ubuntu.id} ${data.aws_ami.latest_x86_64_ubuntu.image_owner_alias} ${data.aws_ami.latest_x86_64_ubuntu.description}"
    value = "\n\t[${data.aws_ami.ubuntu-20_04.creation_date}] Image in region ${var.region}: ${data.aws_ami.ubuntu-20_04.id} ${data.aws_ami.ubuntu-20_04.description}"
}


