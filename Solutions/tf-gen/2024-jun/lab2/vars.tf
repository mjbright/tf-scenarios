
variable "image" {
  type        = string
  description = "The name of the Container Image to use"
  default     = "mjbright/k8s-demo:alpine1"
}

variable "name" {
  type        = string
  description = "The name of the Container to create"
  default     = "demo1"
}

variable "ext_port" {
  type        = number
  description = "The port on which the application will be exposed (on the node ip address)"
  default     = 8001
}

