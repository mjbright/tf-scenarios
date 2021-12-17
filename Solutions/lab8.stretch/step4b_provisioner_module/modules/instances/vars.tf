
variable ami_account {
  description = "AWS account to search for images"
}

variable num_instances {
  description = "Number of EC2 instances to create"
  default = 1
}

variable key_file {
  description = "Path to generated PEM key file"
}

variable user {
  description = "Login user"
  default     = "ubuntu"

}



