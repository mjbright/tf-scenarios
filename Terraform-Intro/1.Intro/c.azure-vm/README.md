
Simple example to create an Azure Virtual Machine "azurerm_linux_virtual_machine"

It demonstrates
- Azure Provider & Resources
- Dependencies between Resources
- The Resources required:
  - resource azurerm_resource_group
  - resource azurerm_virtual_network
  - resource azurerm_subnet
  - resource azurerm_network_interface
  - resource azurerm_public_ip
  - resource azurerm_storage_account
  - resource azurerm_linux_virtual_machine
- variable declarations & overrides from terraform.tfvars
- useful terraform outputs

Steps
- terraform plan  # Observe - we need to init, to take into account the "azurerm" Provider
- terraform init
- terraform apply
- Use example_ssh_command output to connect to Virtual Machine
- terraform destroy

Variations
- TBD ...

