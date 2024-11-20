
variable region {
  default = "UNSET"
}

variable tags {
  description = "Tags to apply to AWS resources"
  default     = {}
  type        = map(string)
}

variable volume_size {
  description = "Root volume size in GB"
  default     = 8
}

variable volume_type {
  description = "Root volume type"
  default     = "gp3"
}

variable ami {
  description = "Specific AMI to use"
  type        = string
  default     = ""
}

variable instance_type {
  description = "EC2 instance type - determines CPU model, # CPUs, RAM"
  type        = string
  default     = "t2.nano"
}

variable key_file {
  description = "Path to provided (Packer) key file"
  type = string
}

variable gen_key_file {
  description = "Path to provided (MacBook) key file"
  type = string
  default = "~/.ssh/id_ed25519"
}

variable user {
  description = "Login user"
  type        = string
  default     = "ubuntu"
}

