
variable aws_region {
    default = "us-west-1"
}

variable names {
    type = list(string)
    default = ["instance1", "instance2" ]
}

variable http_port {
    type = string
    default = "8080"
}

variable server_text {
    type = string
    default = "Your server is up !!"
}

variable key_name {
    default = "20211217-key"
}

