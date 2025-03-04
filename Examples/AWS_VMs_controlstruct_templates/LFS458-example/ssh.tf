
locals {
    pub_ssh_config = (
        templatefile("${path.root}/templates/ssh.tpl", {
            node_names     = keys(var.vms),
            admin_key_file = var.private_key_file,
            user_key_file  = var.private_key_file,
            #node_ips       = ["xx", "yy"]
            #node_ips       = aws_instance.vm[*].public_ip,
            vms            = aws_instance.vm,
            admin_user     = "ubuntu",
            user           = "student",
        }) 
    )
}

resource "local_file" "pub_ssh_config" {
    content   = local.pub_ssh_config
    filename  = format("./ssh_config")
}

