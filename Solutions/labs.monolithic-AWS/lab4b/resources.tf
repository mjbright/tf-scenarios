
resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name           = "Main"
    Location       = "London"
    LabName        = "4b.TerraformMaps"
  }
}

resource "aws_subnet" "vpc_subnets" {
  count = length(var.vpc_subnet_cidr)

  vpc_id             = aws_vpc.main_vpc.id

  #cidr_block        = element(var.vpc_subnet_cidr,count.index)
  cidr_block         = var.vpc_subnet_cidr[count.index]

  #availability_zone = element(var.aaz[var.region],count.index)
  availability_zone  = var.aaz[var.region][count.index]

  tags = {
    Name = "subnet-${count.index+1}"
    LabName = "4b.TerraformMaps"
  }
}
