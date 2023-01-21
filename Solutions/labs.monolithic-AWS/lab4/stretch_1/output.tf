
output  "public_ip"     { value = aws_instance.example.public_ip  }
output  "public_dns"    { value = aws_instance.example.public_dns }
output  "private_ip"    { value = aws_instance.example.private_ip }

output "instance-info"  { value = "Public ip=${aws_instance.example.public_ip} Public_dns=${aws_instance.example.public_dns} Private ip=${aws_instance.example.private_ip}" }

output "SSH_TEST1"      { value = "ssh -i key.pem ${ var.user }@${ aws_instance.example.public_dns } uptime" }

output "SSH_TEST2"      { value = "ssh -i key.pem ${ var.user }@${ aws_instance.example.public_dns } 'echo hostname[$(hostname)]: $(uname -s)/$(uname -r) $(uptime)'" }



