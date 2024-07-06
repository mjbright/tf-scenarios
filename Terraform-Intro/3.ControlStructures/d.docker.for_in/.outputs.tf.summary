
locals {
    vms_names = keys( var.vms )

}

# Produce a pretty-printed summary of VM information:
output summary {
    value = join("\n", 
        [ for elem in local.vms_names :
            format("%s:\thostname:%s network:%s int:%d ext:%d",
                elem,
                var.vms[elem]["hostname"],
                var.vms[elem]["networks"], 
                var.vms[elem]["int_port"], 
                var.vms[elem]["ext_port"], 
            ) ] )
}

