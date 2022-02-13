output subnets { value = aws_subnet.vpc_subnets[*].cidr_block }
output zones   { value = aws_subnet.vpc_subnets[*].availability_zone }
