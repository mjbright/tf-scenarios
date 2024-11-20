# 1. create a Linux Virtual Machine.
#   For this we will use various resource types which we have not yet covered

#  - resource "azurerm_virtual_network"
#  - resource "azurerm_subnet"
#  - resource "azurerm_network_interface"
#  - resource "azurerm_public_ip"
#  - resource "azurerm_storage_account"
#  - resource "azurerm_linux_virtual_machine"
#  - resource "local_file" **WARNING ~/.ssh/config will be overwritten**

provider "azurerm" {
  features {}
  # subscription_id = "xxxx-xxxx-xxxx"
}


