
# Jumphost IP address
variable jumphost_fip {
  default = "1.2.3.4"
}

locals {
  ansible_hosts = templatefile("${path.module}/templates/ansible.tpl", {
      node_names = [ "node1",     "node2"    ],
      node_ips   = [ "10.0.0.1",  "10.0.0.2" ],
      jumphost_fip = var.jumphost_fip,
      user       = "student",
      key_file   = "~/.ssh/student_rsa"
  }) 
}

output ansible_hosts {
    value = local.ansible_hosts
}

resource "local_file" "ansible_hosts" {
    content  = local.ansible_hosts
    filename = "${path.module}/ansible_hosts"
}

