
variable aws_region {
    default = "us-west-1"
}

variable name {
    type = string
    default = "alb-webserver"
}

# CHANGED FROM http_port:
variable web_server_http_port {
    type = string
    default = "8080"
}

variable server_text {
    type = string
    default = "Your server is up !!"
}

variable key_name {
    default = "asg-webservers-key"
}


variable alb_http_port {
   default = 8080
}

