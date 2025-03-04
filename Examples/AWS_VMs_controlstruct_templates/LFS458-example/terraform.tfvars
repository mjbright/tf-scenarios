
#region     = "us-west-1"
region     = "us-west-2"

key_name   = "lfs458"

# Using an existing key created using:
#     ssh-keygen -N '' -t ed25519
private_key_file = "~/.ssh/id_ed25519"

default_vm_config = {
    # AMI from: https://cloud-images.ubuntu.com/locator/ec2/
    # - search "us-west-1 amd64 noble"
    #   ami = "ami-0cee8dedbbfb4bed7"
    # - search "us-west-2 amd64 noble"
    ami = "ami-0b4bfcfff930ca7c0"

    instance_type = "t2.medium"
}

# Keys in below structure determine VMs to be created
# Values provide ami/instance_type overrides:
vms = {
    # EXAMPLES:
    #"vm1" = { instance_type = "t2.micro" },
    #"vm2" = { instance_type = "t2.micro", ami = "ami-0146ae06d23f304b0" },

    # LFS458 (ex 1-15):
    "cp" = { },
    "worker" = { },
    # LFS458 (ex 16):
    # "cp2" = { },
    # "cp3" = { },
    # "lb" = { instance_type = "t2.micro" }
}

