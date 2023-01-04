
locals {
    ssh_config = module.cluster.*.ssh_config
}

output ssh_config {
    value = local.ssh_config
}

resource "local_file" "ssh_config" {
    content  = join("\n", local.ssh_config)
    filename = "${path.module}/var/config"
}

