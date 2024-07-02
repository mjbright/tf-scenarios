
variable container_name {
    description = "The name of the container"
    default     = "lab3-container"
}

variable image_name {
    description = "The image to use"
    default     = "BAD-image"
}

variable int_port {
    description = "Port on which the container listens on (on docker subnet)"
    default     = "80"
}

variable ext_port {
    description = "Port on which we wish to expose the container on the host network"
    default     = "8083"
}

