variable "region" {
  # **** SET A BAD REGION DEFAULT FOR NOW: ****
  default = "us-west-1"
}
variable "vpc_cidr" {
  default = "192.168.0.0/16"
}
variable "vpc_subnet_cidr" {
  default = "192.168.100.0/24"
}
variable "ami_instance" {
  default = "ami-0ac019f4fcb7cb7e6"
}
variable "ami_instance_type" {
  default = "t2.micro"
}
variable "aws_availability_zone" {
  default = "us-west-1a"
}
