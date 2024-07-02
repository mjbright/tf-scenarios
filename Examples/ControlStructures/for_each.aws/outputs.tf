
output vpc_cidr { value = var.vpc_cidr }

output vpc_subnet_cidrs {
  value = [
    for index, subnet in aws_subnet.vpc_subnets:
        format("Subnet[%d]: %s", index(var.vpc_subnet_cidr, subnet.cidr_block), subnet.cidr_block)
  ]
}


