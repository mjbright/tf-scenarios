# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "azurerm_linux_virtual_machine" "vm" {
  admin_password                                         = null # sensitive
  admin_username                                         = "testuser"
  allow_extension_operations                             = true
  availability_set_id                                    = null
  bypass_platform_safety_checks_on_user_schedule_enabled = false
  capacity_reservation_group_id                          = null
  computer_name                                          = "test-import"
  custom_data                                            = null # sensitive
  dedicated_host_group_id                                = null
  dedicated_host_id                                      = null
  disable_password_authentication                        = true
  disk_controller_type                                   = "SCSI"
  edge_zone                                              = null
  encryption_at_host_enabled                             = false
  eviction_policy                                        = null
  extensions_time_budget                                 = "PT1H30M"
  license_type                                           = null
  location                                               = "eastus"
  max_bid_price                                          = -1
  name                                                   = "test-import"
  network_interface_ids                                  = ["/subscriptions/3b20a4d3-fada-4ca5-ba45-463d15da5239/resourceGroups/test-import/providers/Microsoft.Network/networkInterfaces/test-importVMNic"]
  patch_assessment_mode                                  = "ImageDefault"
  patch_mode                                             = "ImageDefault"
  priority                                               = "Regular"
  provision_vm_agent                                     = true
  proximity_placement_group_id                           = null
  reboot_setting                                         = null
  resource_group_name                                    = "test-import"
  secure_boot_enabled                                    = true
  size                                                   = "Standard_DS1_v2"
  source_image_id                                        = null
  tags                                                   = {}
  user_data                                              = null
  virtual_machine_scale_set_id                           = null
  vm_agent_platform_updates_enabled                      = false
  vtpm_enabled                                           = true
  zone                                                   = null
  admin_ssh_key {
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzpgkM60AaUrlPThwkD7mSVg9zGUal1LmLW0dWqAIzE53Gwv5FV0yrtnjqFaGfv8VAj1iyiGhtlMQYcgqaS89n5ww3cYjN+BWwIp1hEePEEbOwn1vLZhYOrun6y3pd77y7Fsx6IdVisFCwg5pKZB0SKz/DKB/DhFkINbNPon46lJs1s2k6qQnTsU7aO7aL271vQAyjxtcXmwUv1jEg8jJNaDg+VrQypBlmypcwW1i6k/5/XqekW4BpW+d1bE76xwPLVMRA4mpGexQAh+twP7rfPFk5p2b+lAkK2vvSDczYWBz+l3JwwbgFYeGaEW89uduAZCFmNuf7Hw/3xL4neMKh"
    username   = "testuser"
  }
  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }
  os_disk {
    caching                          = "ReadWrite"
    disk_encryption_set_id           = null
    disk_size_gb                     = 30
    name                             = "test-import_OsDisk_1_8e861850236343eb8f5d0ae5e0142da7"
    secure_vm_disk_encryption_set_id = null
    security_encryption_type         = null
    storage_account_type             = "Premium_LRS"
    write_accelerator_enabled        = false
  }
  source_image_reference {
    offer     = "0001-com-ubuntu-minimal-jammy"
    publisher = "Canonical"
    sku       = "minimal-22_04-lts-gen2"
    version   = "latest"
  }
}
