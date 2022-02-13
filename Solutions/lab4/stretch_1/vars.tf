variable "region" {
  default = "us-west-1"
}
variable "vpc_cidr" {
  default = "192.168.0.0/16"
}
variable "vpc_subnet_cidr" {
  type = list
  default = ["192.168.100.0/24","192.168.101.0/24","192.168.102.0/24"]
}
variable "ami_instance" {
  default = "ami-0ac019f4fcb7cb7e6"
}
variable "ami_instance_type" {
  default = "t2.micro"
}
variable "aws_availability_zones" {
  type = list

  # Remove us-west-1a:
  # default = ["us-west-1a","us-west-1b","us-west-1c"]
  default = ["us-west-1b","us-west-1c"]
}
