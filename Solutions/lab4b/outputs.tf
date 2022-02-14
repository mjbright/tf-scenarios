
output subnets { value = aws_subnet.vpc_subnets[*].cidr_block }
output zones   { value = aws_subnet.vpc_subnets[*].availability_zone }

output  "public_ip"     { value = aws_instance.example.*.public_ip  }
output  "public_dns"    { value = aws_instance.example.*.public_dns }
output  "private_ip"    { value = aws_instance.example.*.private_ip }

output  "pub_private"   { value = [ for instance in aws_instance.example.* :
    "Public ip:${instance.public_ip} Private ip:${instance.private_ip}"
] }

