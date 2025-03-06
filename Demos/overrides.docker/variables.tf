
variable network_bridge {
    type    = string
    default = "apps"
}

variable int_port {
    type    = number
    default = 80
}

variable domain_name {
    type    = string
    default = "local"
}

variable containers {
    type    = map
    default = {}
}

variable env {
    type    = set(string)
    default = []
}

