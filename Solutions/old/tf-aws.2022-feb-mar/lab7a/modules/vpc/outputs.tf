
output "aaz" { value = aws_subnet.vpc_subnets.*.availability_zone }
output "vpc_subnet_cidr" { value = var.vpc_subnet_cidr }
output "subnet_ids" { value = aws_subnet.vpc_subnets.*.id }

