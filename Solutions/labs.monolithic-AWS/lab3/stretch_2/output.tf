
locals {
  public_ip = aws_instance.example.public_ip
  public_dns = aws_instance.example.public_dns
  private_ip = aws_instance.example.private_ip
}

output  "public_ip"     { value = local.public_ip  }
output  "public_dns"    { value = local.public_dns }
output  "private_ip"    { value = local.private_ip }

output "instance-info"  { value = "Public ip=${local.public_ip} Public_dns=${local.public_dns} Private ip=${local.private_ip}" }

output "SSH_TEST1"      { value = "ssh -i key.pem ${ var.user }@${ local.public_dns } uptime" }

output "SSH_TEST2"      { value = "ssh -i key.pem ${ var.user }@${ local.public_dns } 'echo hostname[$(hostname)]: $(uname -s)/$(uname -r) $(uptime)'" }



