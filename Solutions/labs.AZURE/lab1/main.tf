
# If we had permissions to create new resource_groups, we could
# create them through the azurerm_resource_group resource as show here:

# resource "azurerm_resource_group" "test-rg" {
#   name     = "test-rg"
#   location = "eastus"
# }

# However: in this scenario we will be using an already created group
# so we simply create a variable with the name of the existing group

resource "azurerm_container_group" "example" {
  name                = "test-aci-1group-2container"
  location            = "eastus"

  # if we had created the test-rg group above, we obtain it's name here:
  # resource_group_name = azurerm_resource_group.test-rg.name
  # but we will use the variable we declared
  resource_group_name = var.test-rg-name

  ip_address_type     = "Public"
  dns_name_label      = "studentN-lab1-aci"
  os_type             = "Linux"
  
  container {
    name   = "k8s-demo-1"
    image  = "mjbright/k8s-demo:1"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  container {
    name   = "k8s-demo-2"
    image  = "alpine"
    cpu    = "0.5"
    memory = "1.5"
    commands = [ "/bin/sleep", "infinity" ]
  }

  tags = {
    environment = "training"
  }
}
