
output  "public_ip" {
    value = join("\n",
        [ for idx, vm in aws_instance.vm : "${ idx }: My Public IP address is ${ vm.public_ip }" ] )
}

output  "public_dns" {
    value = join("\n",
        [ for idx, vm in aws_instance.vm : "${ idx }: My Public DNS address is ${ vm.public_dns }" ] )
}

output  "ping_me" {
    value = join("\n",
        [ for idx, vm in aws_instance.vm : "${ idx }: Ping me using command\n\tping -c4 ${ vm.public_ip }" ] )
}

output  "ssh_me" {
    value = join("\n",
        [ for idx, vm in aws_instance.vm : "${ idx }: ssh to this machine using command\n\tssh ubuntu@${ vm.public_ip }" ] )
}

output  "ssh_example" {
    value = join("\n",
        [ for idx, vm in aws_instance.vm : "${ idx }: ssh to this machine using command\n\tssh ubuntu@${ vm.public_ip } echo '$(id -un)@$(hostname) [$(hostname -I)]: $(uptime)'" ] )
}

output  "ssh_example_cfg" {
    value = join("\n",
        [ for idx, vm in aws_instance.vm : "${ idx }: ssh to this machine using command\n\tssh -F ssh_config u${idx} echo '$(id -un)@$(hostname) [$(hostname -I)]: $(uptime)'" ] )
}

output  "ssh_example_cfg_student" {
    value = join("\n",
        [ for idx, vm in aws_instance.vm : "${ idx }: ssh to this machine using command\n\tssh -F ssh_config ${idx} echo '$(id -un)@$(hostname) [$(hostname -I)]: $(uptime)'" ] )
}

