
variable "region" {
    description = "Region in which to create resources"
}

variable "vpc_cidr" {
    description = "CIDR range to use for the VPC"
}

variable "vpc_subnet_cidr" {
    type = list(string)
    description = "list of subnet CIDR ranges to use for VPC subnets"
    # ranges must all lie within the vpc_cidr
}

variable "ami_instance" {
    description = "AMI instance to use (region specific)"
}

variable "instance_type" {
   description = "Type of instance to use (AWS EC2 instance type)"
}

data "aws_availability_zones" "aaz" {}

