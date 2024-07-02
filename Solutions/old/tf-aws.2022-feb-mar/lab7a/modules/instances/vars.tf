
variable "region" {}

variable "ami_instance" {
    type = map
    default = {
        "us-east-1" = "ami-0ac019f4fcb7cb7e6"
        "us-east-2" = "ami-0f65671a86f061fcd"
        "us-west-1" = "ami-063aa838bd7631e0b"
    }
}

variable "ami_instance_type" {
    default = "t2.micro"
}

