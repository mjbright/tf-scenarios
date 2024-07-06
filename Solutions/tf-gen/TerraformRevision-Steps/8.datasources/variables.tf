
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
