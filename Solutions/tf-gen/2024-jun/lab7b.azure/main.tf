
resource azurerm_resource_group rg {
    name     = var.resource_group
    location = var.location
}

module "virtual-machine" {
  # Pull the module source from the Github Repo / sub-folder / commit:
  source = "git::https://github.com/mjbright/terraform-modules.git//modules/kumarvna-azurerm-virtual-machine?ref=180da8586921e63f5a9e5b1b5e826e0d89bc51ed"

  # Pass in resource_group, virtual_network and subnet resources as input variables:
  obj_resource_group       = azurerm_resource_group.rg
  obj_virtual_network      = azurerm_virtual_network.vnet
  obj_subnet               = azurerm_subnet.subnet

  virtual_machine_name = "vm-linux"

  # Select the OS flavour & distribution/release
  os_flavor               = "linux"
  linux_distribution_name = "ubuntu2004"
  virtual_machine_size    = "Standard_B2s"
  generate_admin_ssh_key  = true
  instances_count         = 1

  # Proximity placement group, Availability Set and adding Public IP to VM's are optional.
  # remove these argument from module if you dont want to use it.
  enable_proximity_placement_group = true
  enable_vm_availability_set       = true
  enable_public_ip_address         = true

  # Network Seurity group port allow definitions for each Virtual Machine
  nsg_inbound_rules = [
    {
      name                   = "ssh"
      destination_port_range = "22"
      source_address_prefix  = "*"
    },
        {
      name                   = "http"
      destination_port_range = "80"
      source_address_prefix  = "*"
    },
  ]

  # Boot diagnostics to troubleshoot virtual machines, by default uses managed
  enable_boot_diagnostics = true

  # Attach a managed data disk to the VM
  data_disks = [
    {
      name                 = "disk1"
      disk_size_gb         = 100
      storage_account_type = "StandardSSD_LRS"
    },
    {
      name                 = "disk2"
      disk_size_gb         = 200
      storage_account_type = "Standard_LRS"
    }
  ]
    # log_analytics_workspace_id = data.azurerm_log_analytics_workspace.example.id
  # deploy_log_analytics_agent                 = true
  # log_analytics_customer_id                  = data.azurerm_log_analytics_workspace.example.workspace_id
  # log_analytics_workspace_primary_shared_key = data.azurerm_log_analytics_workspace.example.primary_shared_key

  # Adding additional TAG's to your Azure resources
  tags = {
    ProjectName  = "terraform-training"
    Env          = "training"
    Owner        = "studentN@example.com"
  }
}

