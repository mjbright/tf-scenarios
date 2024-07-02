resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
    
  tags = {
    Name     = "Main"
    LabName  = "3.TerraformVariables"
    Location = "London - with cidr ${var.vpc_cidr}"
  }
}

resource "aws_subnet" "vpc_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.vpc_cidr
  availability_zone = var.aws_availability_zone

  tags = {
    Name    = "subnet1"
    LabName = "3.TerraformVariables"
  }
}
