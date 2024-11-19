# Variable declarations
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable vpc_cidr_block {
    description = "CIDR block for VPC"
    type = string
    default = "10.0.0.0/16"
}

variable instance_count {
  description = "Number of instances to provision."
  type = number
  default = 2
}

