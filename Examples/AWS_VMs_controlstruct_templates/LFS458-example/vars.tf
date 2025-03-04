
locals {
    min_vms = 0
    max_vms = 5
}

variable region {
    description = "AWS region in which to create resources"
    type        = string
    nullable    = false

    default     = "us-west-1"
}

variable vms {
    description = "VM instances to manage & configuration parameters"
    type        = map

    validation {
        condition     = length(keys(var.vms)) >= local.min_vms && length(keys(var.vms)) <= local.max_vms
        error_message = "Invalid number of vms ${ length(keys(var.vms)) } should be in range (${ local.min_vms }-${ local.max_vms })"
    }
}

variable default_vm_config {
    description = "Default Virtual Machine configuration parameters"
    type        = map

    validation {
        condition     = lookup(var.default_vm_config, "ami", "ami-UNSET") != "ami-UNSET"
        error_message = "var.default_vm_config: contains no 'ami' entry"
    }

    validation {
        condition     = can(regex("^ami-([0-9,a-z]+)$", var.default_vm_config["ami"]))
        error_message = "default_vm_config: AMI must be of form ami-xxxxx (where x=[0-9,a-z])"
    }
}

variable key_name {
    description = "Name of aws_key_pair to create from existing key"
    type        = string
    nullable    = false
}

variable private_key_file {
    description = "Path to private key to be used with ssh"
    type        = string
    nullable    = false
}

