resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = var.location
  address_space       = [ "10.0.0.0/16" ]

  resource_group_name = azurerm_resource_group.rg.name

  tags = { source = "terraform" }
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.resource_group}subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [ "10.0.0.0/24" ]

  # Curiously this resource does not have a tags parameter
  # tags = { source = "terraform" }
}
