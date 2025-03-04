
locals {
    vms = { for k, vm in var.vms : k => merge( var.default_vm_config, vm ) }
}

# Create an AWS Virtual Machine Instance:
resource "aws_instance" "vm" {
    for_each      = local.vms

    ami           = local.vms[each.key]["ami"]
    instance_type = local.vms[each.key]["instance_type"]

    tags = {
        Module = "4.ControlStructures",
        Instance = "instance-${ each.key }"
    }

    key_name = aws_key_pair.existing_key.key_name

    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file( pathexpand( var.private_key_file ) )
        host        = self.public_ip
    }

    # Transfer initialization script:
    provisioner "file" {
        source      = "provisioner-scripts/init.sh"
        destination = "/tmp/init.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "set -x\n",
            "chmod +x /tmp/init.sh",

            # Use key as new hostname:
            "sudo bash /tmp/init.sh ${each.key}"
        ]
    }
}

# Create an AWS 'key pair' resource usable for ssh from the provided public key:
resource "aws_key_pair" "existing_key" {
    key_name   = var.key_name

    # Using an existing key created using:
    #     ssh-keygen -N '' -t ed25519
    public_key = file( pathexpand( "${ var.private_key_file }.pub" ))
}

