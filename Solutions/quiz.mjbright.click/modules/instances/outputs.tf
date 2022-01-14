
output "ami"          { value = aws_instance.example.*.ami }

output "public_ip"    { value = aws_instance.example.*.public_ip }

output "public_dns"   { value = aws_instance.example.*.public_dns }

output "key_pair"     { value = aws_key_pair.generated_key.key_name }

output "instances"    { value = aws_instance.example.* }

output "fqdn"         { value = aws_route53_record.my_name.*.fqdn }


