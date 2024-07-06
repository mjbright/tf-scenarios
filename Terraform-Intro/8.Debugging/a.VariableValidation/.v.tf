
variable vm_name {
    type    = string
    default = "humungous-virtual-machine-for-fun"
    #default = "xx"

    validation {
        # Why alltrue ?? why not just use && between condtions ??
        # Why any     ?? why not just use || between condtions ??
        condition = alltrue([
             length( var.vm_name ) >= 5,
             length( var.vm_name ) <= 12
        ])

        # If condition is not met:
        error_message = "VM_name length (is ${ length(var.vm_name) }) must be in the range [ 5 .. 12 ] characters"
    }
}

variable image_name {
    type    = string
    #default = "mjbright/k8s-demo:1"
    default = "local.registry.io/mjbright/k8s-demo:1"

    validation {
        # Images can only be pulled from local registry:
        condition = can( regex( "^local.registry.io/", var.image_name) )

        # If condition is not met:
        error_message = "Forbidden: image ${ var.image_name } is not from local.registry.io"
    }

    validation {
        # Only versioned images can be used:
        condition = can( ! regex( ":latest$", var.image_name) )

        # If condition is not met:
        error_message = "Forbidden: ${ var.image_name } use of ':latest' is not allowed"
    }

    validation {
        # Only versioned images can be used:
        condition = can( regex( ":", var.image_name) )

        # If condition is not met:
        error_message = "Forbidden: ${ var.image_name } image tag must be specified"
    }

    validation {
        # Only versioned images can be used:
        condition = can( ! regex( ":$", var.image_name) )

        # If condition is not met:
        error_message = "Forbidden: ${ var.image_name } image tag is empty"
    }
}



