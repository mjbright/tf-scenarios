
# Set these variables to your 'unique' resource_group:
resource_group = "studentN"
# Note: upper-case characters not allowed here:
dns_name = "studentn"

rg_prefix = "terraform-linux-vms-linux"
location  = "eastus"

hostname = "vm-linux-docker"

virtual_network_name = "terraform-vnet"
address_space        = "10.0.0.0/16"
subnet_prefix        = "10.0.10.0/24"

storage_account_tier     = "Standard"
storage_replication_type = "LRS"

vm_size         = "Standard_D2s_v3"
image_publisher = "Canonical"
image_offer     = "0001-com-ubuntu-confidential-vm-focal"
image_sku       = "20_04-lts-cvm"
image_version   = "20.04.202306140"

admin_username = "vmadmin"

# Set this value to the ssh key generated earlier, or your own key:
admin_priv_key = "~/.ssh/test_rsa"

