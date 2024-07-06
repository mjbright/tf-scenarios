
# This file contains the minimum set of "azurerm" resources we need to create a virtual machine.
#
# In this example we create a "azurerm_linux_virtual_machine" instance ("azurerm_windows_virtual_machine" is also possible)
#
# Note that:
# - all azure resources are created in an Azure Resource Group
# - Creating a Virtual Machine connected to a Network requires creation of the following resources:
#   - resource "azurerm_virtual_network"
#   - resource "azurerm_subnet"
#   - resource "azurerm_network_interface"
#   - resource "azurerm_public_ip"
#   - resource "azurerm_storage_account"
#
# Terraform will parse this configuration to build a 'Plan' containing a graph of dependencies
#
# This will allow Terraform to create dependent resources in the correct order,
# e.g. the Resource Group must be created before any other resources
#      the Subnet         must be created before the Virtual Network
#      ...

# Note: we create an azurerm_resource_group with name provided by var.resource_group:
#
# Note: See the important notes below about var.resource_group
#
resource azurerm_resource_group rg {
  location = var.location
  name     = var.resource_group
}

resource azurerm_virtual_network vnet {
  name                = "${var.rg_prefix}-${var.virtual_network_name}"
  location            = var.location
  address_space       = [ var.address_space ]

  # NOTE: we could use var.resource_group here but we could then run into race conditions
  #       where the creation of this resource fails because the resource group is not yet created
  #
  #       Using the azurerm_resource_group.rg.name reference informs Terraform of the dependency between resources
  #       so that resources are created in the correct order
  #
  resource_group_name = azurerm_resource_group.rg.name

  tags = { source = "terraform" }
}

resource azurerm_subnet subnet {
  name                 = "${var.rg_prefix}subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name

  # NOTE: we could use var.resource_group here but we could then run into race conditions
  resource_group_name  = azurerm_resource_group.rg.name

  address_prefixes     = [ var.subnet_prefix ]

  # Curiously this resource does not have a tags parameter
  # tags = { source = "terraform" }
}

resource azurerm_network_interface nic {
  name                = "${var.rg_prefix}nic"
  location            = var.location

  # NOTE: we could use var.resource_group here but we could then run into race conditions
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.rg_prefix}ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }

  tags = { source = "terraform" }
}

resource azurerm_public_ip pip {
  name                         = "${var.rg_prefix}-ip"
  location                     = var.location

  # NOTE: we could use var.resource_group here but we could then run into race conditions
  resource_group_name          = azurerm_resource_group.rg.name

  allocation_method            = "Dynamic"
  domain_name_label            = lower( var.dns_name )

  tags = { source = "terraform" }
}

resource azurerm_storage_account stor {
  name                     = lower( "${var.dns_name}storage" )
  location                 = var.location

  # NOTE: we could use var.resource_group here but we could then run into race conditions
  resource_group_name      = azurerm_resource_group.rg.name

  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type

  tags = { source = "terraform" }
}

resource azurerm_linux_virtual_machine vm {
  name                  = "${var.rg_prefix}vm"
  location              = var.location

  # NOTE: we could use var.resource_group here but we could then run into race conditions
  resource_group_name   = azurerm_resource_group.rg.name

  size                  = var.vm_size
  network_interface_ids = [ azurerm_network_interface.nic.id ]

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  os_disk {
   name              = "${var.hostname}-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name  = var.hostname
  admin_username = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
     username = var.admin_username
     public_key = file( join( "", [ pathexpand(var.admin_priv_key), ".pub" ] ) )
  }

  tags = { source = "terraform" }
}

