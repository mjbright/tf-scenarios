
#output "amis_latest_ubuntu_2004_LTS" { value = data.aws_ami.latest_ubuntu_lts_2004.id }
#output "amis_latest_ubuntu_1804_LTS" { value = data.aws_ami.latest_ubuntu_lts_1804.id }
output "VM_ami_id"                    { value = aws_instance.example.ami }

output "public_ip"        { value = aws_instance.example.public_ip }

#output "key_pair"        { value = aws_key_pair.generated_key.key_name }

#output "SSH_rsa_pub_key" { value = tls_private_key.tmpkey.public_key_openssh }

#output "SSH_pem_key"      {
#  value = tls_private_key.tmpkey.private_key_pem
#  sensitive = true
#}

output "SSH_connect" {
  value = "ssh -i ${var.key_file} ${var.user}@${aws_instance.example.public_ip}"
}

output "SSH_test" {
  value = "ssh -i ${var.key_file} ${var.user}@${aws_instance.example.public_ip} 'echo hostname[$(hostname)]: $(uname -s)/$(uname -r) $(uptime)'"
}

output "WEB_ip" { value = "curl -sL http://${aws_instance.example.public_ip}:8080" }
output "WEB_dns" { value = "curl -sL http://${aws_instance.example.public_dns}:8080" }


