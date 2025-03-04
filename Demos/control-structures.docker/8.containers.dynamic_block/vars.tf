
variable network_name {
    type        = string
    description = "Set name to create new bridge network - else use default"
    default     = null
}

variable image_names {
    type        = list( string )
    description = "Set name of docker_image(s) - must be set"
    nullable    = false

    validation {
        # 0 or more images
        # either:
        # - each container uses same image
        # - each container has it's own image (container count.index used to index into image_names)
        condition     = (length(var.image_names) >= 0 && (
            length(var.image_names) == 1 || length(var.image_names) == var.container_count)
        )
        error_message = "Number of images = ${ length(var.image_names) }, must be equal to either 0, 1 or number of containers"
    }
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

