
provider aws { region = var.region }

variable region { default = "us-west-1" }

data "aws_ami_ids" "my_images" {
  owners           = ["self"]
}

output my_images {
  value = data.aws_ami_ids.my_images.ids
}

output my_images_id {
  value = data.aws_ami_ids.my_images.id
}



