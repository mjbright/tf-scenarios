
// output "VM_fqdns" { value = [ for index, fqdn in module.instances.fqdn.* : fqdn ] }

locals {
  fqdns = [ for index, fqdn in module.instances.fqdn.* : fqdn ]
}


output "VM_info" {
  value = [ for index, example in module.instances.instances.* : format("%s%s", "\n    ", join( "\n    ", [
    "================ Machine ${ index } details: ================",
    "AMI        :\t${ example.ami }",
    "PUBLIC_IP  :\t${ example.public_ip }",
    "FQDN       :\t${ local.fqdns[index] }",
    "\n",
    "SSH_CONNECT:\tssh -i ${ var.key_file } ${ var.user }@${ local.fqdns[index] }",
    "SSH_TEST   :\tssh -i ${ var.key_file } ${ var.user }@${ local.fqdns[index] } 'echo hostname[$(hostname)]: $(uname -s)/$(uname -r) $(uptime)'" ,
    "\n",
    "CURL_IP    :\tcurl -sL http://${ local.fqdns[index] }:8080" ,
    "CURL_DNS   :\tcurl -sL http://${ example.public_dns }:8080",
    #"SSH_CONNECT:\tssh -i ${ var.key_file } ${ var.user}@${ local.fqdns[index] }",
    #"SSH_TEST   :\tssh -i ${ var.key_file } ${ var.user}@${ local.fqdns[index] } 'echo hostname[$(hostname)]: $(uname -s)/$(uname -r) $(uptime)'" ,
    #"\n",
    #"CURL_IP    :\tcurl -sL http://${ local.fqdns[index] }:8080" ,
    #"CURL_DNS   :\tcurl -sL http://${ example.public_dns }:8080",
   ]) )]
}



