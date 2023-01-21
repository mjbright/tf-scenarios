resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name     = "Main"
    Location = "London"
    LabName  = "4.ControlStructures"
  }
}

resource "aws_subnet" "vpc_subnets" {
  count = length(var.aws_availability_zones)

  vpc_id            = aws_vpc.main_vpc.id

  cidr_block        = var.vpc_subnet_cidr[count.index]

  availability_zone = var.aws_availability_zones[count.index]

  tags = {
    Name    = "subnet-${count.index+1}"
    LabName = "4.ControlStructures"
  }
}
