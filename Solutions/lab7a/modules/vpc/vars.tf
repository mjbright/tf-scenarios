
variable "region" {}

data "aws_availability_zones" "aaz" {}

variable "vpc_cidr" {
  default = "192.168.0.0/16"
}

variable "vpc_subnet_cidr" {
  type    = list(any)
  default = ["192.168.100.0/24", "192.168.101.0/24", "192.168.102.0/24"]
}

variable "ami_instance" {
  type = map(any)
  default = {
    "us-east-1" = "ami-0ac019f4fcb7cb7e6"
    "us-east-2" = "ami-0f65671a86f061fcd"
    "us-west-1" = "ami-063aa838bd7631e0b"
    "eu-west-3" = "ami-0df03c7641cf41947"
  }
}

variable "ami_instance_type" {
  default = "t2.micro"
}

