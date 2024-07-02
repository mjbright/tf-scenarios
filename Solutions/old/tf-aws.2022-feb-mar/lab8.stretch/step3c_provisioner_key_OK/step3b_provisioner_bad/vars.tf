
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


