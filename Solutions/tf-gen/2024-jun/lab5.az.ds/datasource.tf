
data "azurerm_resources" "all-in-group" {
  resource_group_name = var.resource_group
}

data "azurerm_resources" "vms-in-group" {
  resource_group_name = var.resource_group
  type                = "Microsoft.Compute/virtualMachines"
}

