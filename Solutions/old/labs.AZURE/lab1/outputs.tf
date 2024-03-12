
locals {
  fqdn   = azurerm_container_group.example.fqdn
  pub_ip = azurerm_container_group.example.ip_address
  port   = "80"
}

output "aci_fqdn" {
  value = local.fqdn
}

output "aci_pub_ip" {
  value = local.pub_ip
}

output "curl_fqdn" {
  value = "curl -L ${local.fqdn}:${local.port}"
}


output "curl_ip" {
  value = "curl -L ${local.pub_ip}:${local.port}"
}

