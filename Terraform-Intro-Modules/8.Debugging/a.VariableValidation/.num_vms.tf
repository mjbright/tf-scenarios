
variable num_vms {
    type    = number
    default = 101

    # Comparing this variable against the hard limit of '100':
    validation {
        condition   = var.num_vms <= 100

        # If condition is not met:
        error_message = "Too many VMs ${ var.num_vms } - you are beyond your quota (100)"
    }
}

