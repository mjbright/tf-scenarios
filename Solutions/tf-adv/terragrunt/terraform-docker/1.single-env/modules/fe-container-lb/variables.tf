
variable network_name {
    type        = string
    description = "Set name of existign be bridge network"
    nullable    = false
}

variable container_name {
    type        = string
    description = "Set name of load-balancer docker_container"
    nullable    = false
}

variable ext_port {
    type        = string
    description = "LB listening port on host network interface"
    nullable    = false
}

variable ext_dashboard_port {
    type        = string
    description = "LB dashboard listening port on host network interface"
    default     = 9999
}

variable haproxy_cfg_abs_dir {
    type        = string
    description = "Absolute path to folder where haproxy.cfg to be created"
    nullable    = false

    validation {
        condition = var.haproxy_cfg_abs_dir == abspath( var.haproxy_cfg_abs_dir )
        error_message = "Error: Absolute path to haproxy.cfg to generate must be provided ( ${ var.haproxy_cfg_abs_dir } )"
    }
}

variable be_servers {
    type        = list(string)
    description = "List of server ips"
    nullable    = false
}


