
locals {
  ssh_config = templatefile("${path.module}/templates/ssh.tpl", {
      node_names = [ "node1",     "node2"    ],
      node_ips   = [ "10.0.0.1",  "10.0.0.2" ],
      user       = "student",
      key_file   = "~/.ssh/student_rsa"
  }) 
}

output ssh_config {
    value = local.ssh_config
}

