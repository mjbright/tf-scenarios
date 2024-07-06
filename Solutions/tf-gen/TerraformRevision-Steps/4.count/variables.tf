
variable container_names {
  type = list(string)

  default = [ "c1", "c2", "c3", "c4", "c5" ]
}

variable domain_name {
  type = string

  default = "local"
}
