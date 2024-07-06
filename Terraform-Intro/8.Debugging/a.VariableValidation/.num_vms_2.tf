
variable vm_quota {
    default = 50

    validation {
        condition   = var.vm_quota >= 0

        # If condition is not met:
        error_message = "VM quota (${ var.vm_quota }) must be in the range [ 0 .. 50 ]"
    }
}

variable num_vms {
    type    = number
    default = 60
    #default = -1

    # New feature in Terraform 1.9.0:
    # - ability to refer to other variables (vm_quota) within this rule:
    validation {
        condition   = var.num_vms <= var.vm_quota

        # If condition is not met:
        error_message = "Too many VMs ${ var.num_vms } - you are beyond your quota (${ var.vm_quota })"
    }

    validation {
        condition   = var.num_vms >= 0

        # If condition is not met:
        error_message = "VM instances (${ var.num_vms }) must be in the range [ 0 .. ${ var.vm_quota } ]"
    }
}

