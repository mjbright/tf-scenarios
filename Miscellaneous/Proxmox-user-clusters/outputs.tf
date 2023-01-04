
locals {
   command = "echo -e '$(id -un)@$(hostname): $(uptime)\\n\\t$(hostname -I)'"
}

output ssh {
    value = [ for c, cluster in module.cluster.* : [ for i, instance in cluster.instances.* :
        format("[cluster[%d]-node[%d] %s %s %s@%s",
            c, i, "ssh -i", var.admin_private_key_file, var.user, instance.default_ipv4_address)
        ]
    ]
}

output ssh_info {
    value = [ for c, cluster in module.cluster.* : [ for i, instance in cluster.instances.* :
        format("[cluster[%d]-node[%d] %s %s %s@%s %s",
            c, i, "ssh -i", var.admin_private_key_file, var.user, instance.default_ipv4_address,
                      local.command)
        ]
    ]
}

