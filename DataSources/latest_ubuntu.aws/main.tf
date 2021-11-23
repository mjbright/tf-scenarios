
provider aws { region = var.region }

variable region { default = "us-west-1" }

data "aws_ami" "latest_x86_64_ubuntu" {
  owners           = ["099720109477"]
  most_recent      = true
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Too much output:
#data "aws_ami_ids" "ubuntu" {
#  owners           = ["099720109477"]
#}
#output ubuntu_images {
#    value = data.aws_ami_ids.ubuntu.ids
#}


output ubuntu_latest {
    #value = "[${data.aws_ami.latest_x86_64_ubuntu.creation_date}] Image ${data.aws_ami.latest_x86_64_ubuntu.id} ${data.aws_ami.latest_x86_64_ubuntu.image_owner_alias} ${data.aws_ami.latest_x86_64_ubuntu.description}"
    value = "[${data.aws_ami.latest_x86_64_ubuntu.creation_date}] Image in region ${var.region}: ${data.aws_ami.latest_x86_64_ubuntu.id} ${data.aws_ami.latest_x86_64_ubuntu.description}"
}


