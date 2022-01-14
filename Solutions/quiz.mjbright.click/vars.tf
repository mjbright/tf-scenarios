
variable key_file {
  description = "Path to generated PEM key file"
}

variable user {
  description = "Login user"
  default     = "ubuntu"
 
}

locals {
  canonical_account_number = "099720109477"
}

variable ingress_ports {
  description = "Ingress Ports"
  type = map(number)
}

variable egress_ports {
  description = "Egress Ports"
  type = map(number)
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
