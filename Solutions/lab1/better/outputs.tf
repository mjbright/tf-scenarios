
output  "public_ip" {
    value = "My Public IP address is ${aws_instance.example.public_ip}"
}

output  "public_dns" {
    value = "My Public DNS address is ${aws_instance.example.public_dns}"
}

