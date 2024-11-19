
output public_ip {
    value = aws_instance.tf-example.public_ip
}

output ips {
    value = "PUB=${ aws_instance.tf-example.public_ip } PRIVATE=${ aws_instance.tf-example.private_ip }"
}


