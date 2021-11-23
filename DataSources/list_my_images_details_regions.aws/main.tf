
provider aws {
  alias  = "uswest1"
  #alias  = var.provider_aliases[0]
  region = var.regions[0]
}

provider aws {
  alias  = "uswest2"
  #alias  = var.provider_aliases[1]
  region = var.regions[1]
}

provider aws {
  alias  = "useast1"
  #alias  = var.provider_aliases[2]
  region = var.regions[2]
}

provider aws {
  alias  = "useast2"
  #alias  = var.provider_aliases[3]
  region = var.regions[3]
}

variable provider_aliases {
    default = [ "uswest1", "aws1", "aws2", "aws3" ]
}
variable regions {
    default = [ "us-west-1", "us-west-2", "us-east-1", "us-east-2" ]
}

data "aws_ami_ids" "uswest1" {
  owners   = ["self"]
  provider = aws.uswest1
}
data "aws_ami_ids" "uswest2" {
  owners   = ["self"]
  provider = aws.uswest2
}
data "aws_ami_ids" "useast1" {
  owners   = ["self"]
  provider = aws.useast1
}
data "aws_ami_ids" "useast2" {
  owners   = ["self"]
  provider = aws.useast2
}

data "aws_ami" "uswest1" {
  count = length(data.aws_ami_ids.uswest1.ids)
  provider = aws.uswest1
  owners   = ["self"]

  filter {
    name   = "image-id"
    values = [ data.aws_ami_ids.uswest1.ids[count.index] ]
  }
}

data "aws_ami" "uswest2" {
  count = length(data.aws_ami_ids.uswest2.ids)
  provider = aws.uswest2
  owners   = ["self"]

  filter {
    name   = "image-id"
    values = [ data.aws_ami_ids.uswest2.ids[count.index] ]
  }
}

data "aws_ami" "useast1" {
  count = length(data.aws_ami_ids.useast1.ids)
  provider = aws.useast1
  owners   = ["self"]

  filter {
    name   = "image-id"
    values = [ data.aws_ami_ids.useast1.ids[count.index] ]
  }
}

data "aws_ami" "useast2" {
  count = length(data.aws_ami_ids.useast2.ids)
  provider = aws.useast2
  owners   = ["self"]

  filter {
    name   = "image-id"
    values = [ data.aws_ami_ids.useast2.ids[count.index] ]
  }
}

output my_images_uswest1 {
  value = data.aws_ami_ids.uswest1.ids
}

output my_images_uswest2 {
  value = data.aws_ami_ids.uswest2.ids
}

output my_images_useast1 {
  value = data.aws_ami_ids.useast1.ids
}

output my_images_useast2 {
  value = data.aws_ami_ids.useast2.ids
}

output my_images_us {
  value = concat(data.aws_ami_ids.uswest1.ids, data.aws_ami_ids.uswest2.ids, data.aws_ami_ids.useast1.ids, data.aws_ami_ids.useast2.ids)
}

#output my_images_uswest1_id {
  #value = data.aws_ami_ids.uswest1.id
#}

locals {
    my_images_info_uswest1 = [ for my_image in data.aws_ami.uswest1: "[${my_image.creation_date}]<${my_image.image_location}> Image ${my_image.id} ${my_image.description}" ]
    my_images_info_uswest2 = [ for my_image in data.aws_ami.uswest2: "[${my_image.creation_date}]<${my_image.image_location}> Image ${my_image.id} ${my_image.description}" ]
    my_images_info_useast1 = [ for my_image in data.aws_ami.useast1: "[${my_image.creation_date}]<${my_image.image_location}> Image ${my_image.id} ${my_image.description}" ]
    my_images_info_useast2 = [ for my_image in data.aws_ami.useast2: "[${my_image.creation_date}]<${my_image.image_location}> Image ${my_image.id} ${my_image.description}" ]
}

output my_images_info_us {
  value = concat(
        ["-- us-west-1: ------"],
        local.my_images_info_uswest1,
        ["-- us-west-2: ------"],
        local.my_images_info_uswest2,
        ["-- us-east-1: ------"],
        local.my_images_info_useast1,
        ["-- us-east-2: ------"],
        local.my_images_info_useast2,)
}

#output my_images_info_uswest1 {
  #value = [ for my_image in data.aws_ami.uswest1: "[${my_image.creation_date}]<${my_image.image_location}> Image ${my_image.id} ${my_image.description}" ]
#}


