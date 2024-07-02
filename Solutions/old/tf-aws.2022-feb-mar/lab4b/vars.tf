
variable "region" {
  default = "us-west-1"
}
variable "vpc_cidr" {
  default = "192.168.0.0/16"
}
variable "vpc_subnet_cidr" {
  type = list
  # Reduced to 2-elements each due to non-availability of us-west-1a:
  #default = ["192.168.100.0/24","192.168.101.0/24","192.168.102.0/24"]
  default = ["192.168.101.0/24","192.168.102.0/24"]
}
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
variable "aaz" {
  type = map
  default = {
    #"us-east-1" = ["us-east-1a","us-east-1b","us-east-1c"]
    #"us-east-2" = ["us-east-2a","us-east-2b","us-east-2c"]
    #"us-west-1" = ["us-west-1a","us-west-1b","us-west-1c"]

    # Reduced to 2-elements each due to non-availability of us-west-1a:
    #"us-east-1" = ["us-east-1b","us-east-1c"]
    #"us-east-2" = ["us-east-2b","us-east-2c"]
    "us-west-1" = ["us-west-1b","us-west-1c"]
  }
} 
