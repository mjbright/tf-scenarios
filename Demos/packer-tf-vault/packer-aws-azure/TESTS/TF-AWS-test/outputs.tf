
locals {
  key_file     = "${ pathexpand( var.key_file ) }"
  gen_key_file = "${ pathexpand( var.gen_key_file ) }"
  ip           = aws_instance.testvm.public_ip
  fqdn         = aws_instance.testvm.public_ip
}

output ami        { value = aws_instance.testvm.ami }

output public_ip  { value = aws_instance.testvm.public_ip }

output private_ip { value = aws_instance.testvm.private_ip }

output public_dns { value = aws_instance.testvm.public_dns }

output key_pair   { value = aws_key_pair.provided_key.key_name }

output instance   { value = aws_instance.testvm }

output ssh_u      {
  value = "ssh -i ${ local.key_file } ubuntu@${ local.fqdn }"
}

output ssh_u_test {
  value = "ssh -i ${ local.key_file } ubuntu@${ local.fqdn } 'echo $(id -un)@$(hostname): $(hostname -i) $(uptime)'"
}

output ssh_s      {
  value = "ssh -i ${ local.gen_key_file } student@${ local.fqdn }"
}

output ssh_s_test {
  value = "ssh -i ${ local.gen_key_file } student@${ local.fqdn } 'echo $(id -un)@$(hostname): $(hostname -i) $(uptime)'"
}

output "ssh_cnxn_ubuntu" {
  value = "ssh -i ~/.ssh/packer_ed25519 ubuntu@${local.fqdn}"
}

output "ssh_cnxn_ubuntu_2" {
  value = "ssh -i ~/.ssh/labs/lab43_admin_ed25519 ubuntu@${local.fqdn}"
}

output "ssh_cnxn_student" {
  value = "ssh -i ~/.ssh/labs/lab43_ed25519 student@${local.fqdn}"
}

output "ssh_hello_ubuntu" {
  value = "ssh -i ~/.ssh/labs/lab43_admin_ed25519 ubuntu@${local.fqdn} 'echo $(id -un)@$(hostname): $(hostname -i) $(docker ps) $(docker --version) $(uptime)'"
}

output "ssh_hello_student" {
  value = "ssh -i ~/.ssh/labs/lab43_ed25519 student@${local.fqdn} 'echo $(id -un)@$(hostname): $(hostname -i) $(docker ps) $(docker --version) $(uptime)'"
}

