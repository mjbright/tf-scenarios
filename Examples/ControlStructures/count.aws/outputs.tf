
output vpc_cidr { value = var.vpc_cidr }
output vpc_subnet_cidrs {
  value = [
    for index, subnet in aws_subnet.vpc_subnets:
        #format("Subnet[%s]: %s", tostring(subnet), subnet.cidr_block)
        format("Subnet[%d]: %s", index, subnet.cidr_block)
  ]
}


