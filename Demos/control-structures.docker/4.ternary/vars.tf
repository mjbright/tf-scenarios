
variable "images" {
  type        = list(string)
  description = "The name of the Container Image to use"
  default     = [ "mjbright/k8s-demo:alpine1", "mjbright/k8s-demo:alpine2", "mjbright/k8s-demo:alpine3", "mjbright/k8s-demo:alpine4", "mjbright/k8s-demo:alpine5", "mjbright/k8s-demo:alpine6" ]
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

