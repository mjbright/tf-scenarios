
variable ami_account {
  description = "AWS account to search for images"
  type        = string
}

variable num_instances {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}

variable key_file {
  description = "Path to generated PEM key file"
  type = string
}

variable user {
  description = "Login user"
  type        = string
  default     = "ubuntu"
}

variable ingress_ports {
  description = "Ingress Ports"
  type        = map(number)
}

variable egress_ports {
  description = "Egress Ports"
  type        = map(number)
}

variable domain {
  description = "DNS domain name"
  type        = string
}

variable zone_id {
  description = "DNS zone_id"
  type        = string
}

variable user_data_filepath {
  description = "Optional path to user_data for VM provisioning"
  type        = string
}

