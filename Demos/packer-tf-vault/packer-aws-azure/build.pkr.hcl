
build {
  sources = var.source_builds

  #provisioner "ansible" {
    #extra_arguments = ["--scp-extra-args", "'-O'", "--ssh-extra-args", "-o IdentitiesOnly=yes -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa"]
    #playbook_file   = "nginx.yaml"
    #user            = "ubuntu"
  #}

  provisioner "file" {
    sources     = [ pathexpand( "~/tmp/IT.SETUP/LFD459-student.zip" ) ]
    destination = "/tmp/files1.zip"
  }

  # To allow debugging: allow early ssh access (to test!) - looks like ssh is blocked ...
  provisioner "shell" {
    environment_vars = [
        "PACKAGES=${ var.apt_packages }"
    ]
    script     = "provisioner-scripts/setup.sh"
  }
}

## Proxmox Sources: =============================================================

build {

    name    = "ubuntu-server-noble-numbat"
    sources = var.proxmox_source_builds

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo rm -f /etc/netplan/00-installer-config.yaml",
            "sudo sync"
        ]
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source      = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }

  provisioner "file" {
    sources     = [ pathexpand( "~/tmp/IT.SETUP/LFD459-student.zip" ) ]
    destination = "/tmp/files1.zip"
  }

  # To allow debugging: allow early ssh access (to test!) - looks like ssh is blocked ...
  provisioner "shell" {
    environment_vars = [
        "PACKAGES=${ var.apt_packages }"
    ]
    script     = "provisioner-scripts/setup.sh"
  }
}

