
variable base_ext_port {
    type        = number
    description = "Base external port on which these containers will listen on host interface"
    nullable    = false
}

variable image_names {
    type        = list( string )
    description = "Set name of docker_image(s) - must be set"
    nullable    = false

    # NEW VERSION: Allow number of images != number of containers:
    validation {
        # 1 or more images
        condition     = length(var.image_names) >= 0
        error_message = "Number of images = ${ length(var.image_names) }, must be greater than or equal to 1"
    }
}

variable network_name {
    type        = string
    description = "Set name to create new bridge network - else use default"
    default     = "apps"
}

variable container_name_prefix {
    type        = string
    description = "Set name of docker_containers"
    default     = "c"
}

variable container_count {
    type        = number
    description = "Set number of identical docker_containers"
    default     = 1
}


