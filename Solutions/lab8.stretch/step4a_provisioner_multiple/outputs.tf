
output "zMACHINES" {
  value = [ for index, example in aws_instance.example.* : format("%s%s", "\n    ", join( "\n    ", [
    "================ Machine ${index} details: ================",
    "AMI        :\t${example.ami}",
    "PUBLIC_IP  :\t${example.public_ip}",
    "\n",
    "SSH_CONNECT:\tssh -i ${var.key_file} ${var.user}@${example.public_ip}",
    "SSH_TEST   :\tssh -i ${var.key_file} ${var.user}@${example.public_ip} 'echo hostname[$(hostname)]: $(uname -s)/$(uname -r) $(uptime)'" ,
    "\n",
    "CURL_IP    :\tcurl -sL http://${example.public_ip}:8080" ,
    "CURL_DNS   :\tcurl -sL http://${example.public_dns}:8080",
   ]) )]
}



