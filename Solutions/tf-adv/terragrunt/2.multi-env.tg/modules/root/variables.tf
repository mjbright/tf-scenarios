
variable be_network_name {
    description = "Name of the backend bridge network to be created"
    nullable    = false
    type        = string
}

variable image_names {
    description = "Names of the backend server container images"
    default     = [ "mjbright/k8s-demo:1" ]
    type        = list(string)
}

variable container_count {
    description = "Number of backend servers to create"
    default     = 3
    type        = number
}

variable base_port {
    description = "Base port on host network for backend servers"
    default     = 6000
    type        = number
}

variable name_prefix {
    description = "Prefix for backend server container names"
    default     = "be"
    type        = string
}

variable lb_name {
    description = "Container name of the load-balancer"
    default     = "lb"
    type        = string
}

variable lb_port {
    description = "Port on host network for load-balancer"
    default     = 8000
    type        = number
}

variable ext_dashboard_port {
    description = "Dashboard Port on host network for load-balancer"
    default     = 9999
    type        = number
}

