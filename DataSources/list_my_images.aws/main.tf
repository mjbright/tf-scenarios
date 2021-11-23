
provider aws { region = var.region }

variable region { default = "us-west-1" }

data "aws_ami_ids" "my_images" {
  owners           = ["self"]
}

data "aws_ami" "my_image" {
  count = length(data.aws_ami_ids.my_images.ids)
  owners   = ["self"]

  filter {
    name   = "image-id"
    values = [ data.aws_ami_ids.my_images.ids[count.index] ]
  }
}

output my_images {
  value = data.aws_ami_ids.my_images.ids
}

output my_images_id {
  value = data.aws_ami_ids.my_images.id
}

output my_images_info {
  value = [ for my_image in data.aws_ami.my_image.*: "[${my_image.creation_date}] Image ${my_image.id} ${my_image.description}" ]
}


