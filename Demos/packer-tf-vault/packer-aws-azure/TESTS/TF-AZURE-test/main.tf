
resource "azurerm_resource_group" "example" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.rg_prefix}-${var.virtual_network_name}"
  location            = var.location
  address_space       = [ var.address_space ]
  resource_group_name = azurerm_resource_group.example.name

  tags = { source = "terraform" }
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.rg_prefix}subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.example.name
  address_prefixes     = [ var.subnet_prefix ]

  # Curiously this resource does not have a tags parameter
  # tags = { source = "terraform" }
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.rg_prefix}nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "${var.rg_prefix}ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }

  tags = { source = "terraform" }
}

resource "azurerm_public_ip" "pip" {
  # WARNING: Combination of location + resource_group must be globally unique

  name                         = "${var.rg_prefix}-ip"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.example.name
  allocation_method            = "Dynamic"

  # OPTIONAL(generally): but if included label + resource group must be GLOBALLY UNIQUE (used to construct DNS FQDN)
  # NEEDED for this config as we pickup fqdn in outputs.tf
  domain_name_label            = "mjbc-${var.dns_name}"

  tags = { source = "terraform" }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${var.rg_prefix}vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.example.name
  size                  = var.vm_size
  network_interface_ids = [ azurerm_network_interface.nic.id ]

  source_image_id = var.image_id
  #source_image_reference {
    #publisher = var.image_publisher
    #offer     = var.image_offer
    #sku       = var.image_sku
    #version   = var.image_version
  #}

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

  # REMOVED - due to apparent TF/azurerm bug on storage_account:
  #boot_diagnostics {
  #  storage_account_uri = azurerm_storage_account.stor.primary_blob_endpoint
  #}
  tags = { source = "terraform" }
}


