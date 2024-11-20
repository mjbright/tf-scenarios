---
title:  TF_Lab2._Workflow
date:   1705870823
weight: 20
---
```bash

```

    # Notebook initial generation:
    # - 2023-Aug-23 19h36m:[cp[terraform]] node cp[terraform 1.5.5]





![](/images/ThinPurpleBar.png)


# Terraform Workflow

![](/images/TF-Azure_Labs_png/Azure_Lab2_1.png)



![](/images/ThinPurpleBar.png)


# Background:

You should already have the following:

1. Terraform installed with appropriate Azure credentials

In this lab we will
1. create a Linux Virtual Machine.
  For this we will use various resource types which we have not yet covered
  - resource "azurerm_virtual_network"
  - resource "azurerm_subnet"
  - resource "azurerm_network_interface"
  - resource "azurerm_public_ip"
  - resource "azurerm_storage_account"
  - resource "azurerm_linux_virtual_machine"
  - resource "local_file" **WARNING ~/.ssh/config will be overwritten**
2. Extend the Terraform configuration to create an **ansible_inventory** file
3. Use ansible to install Docker on the Virtual Machine

#### Details

The goal is not to go into depth on those resources - for now at least - but to have a real Terraform use case.

We will also install Docker on that VM allowing us to test basic Terraform concepts as we cover them without having the delay of creating cloud resources such as VMs each time.

Working with Docker will give us **go faster stripes :)** for experimenting with Terraform.

So there are many Terraform concepts which we haven't yet covered to achieve this goal.



![](/images/ThinPurpleBar.png)


## 1.1 Saving disk space - setting TF_DATA_DIR

<p style="display: inline-block; border-width:3px; border-style:solid; border-color:#0000AA; background-color: #ffffff; border-radius: 15px; padding: 1em;"><b>Note: </b> to save disk space you can now remove the terraform binary and use the one located at <i>/usr/local/bin/terraform</i>.
</p>


You may need to run 'hash -r' in your bash/zsh shell so that the binary is now found in that location.

<p style="display: inline-block; border-width:3px; border-style:solid; border-color:#0000AA; background-color: #ffffff; border-radius: 15px; padding: 1em;"><b>Note: </b> Also please run the command <i>export TF_DATA_DIR=~/dot.terraform</i> and  add this file into your <i>~/.bashrc</i> file.  This will avoid making a local copy of the huge Azure provider in each labs directory which we use.
</p>


*IFF* you have environment variable **TF_DATA_DIR** set to ~/dot.terraform then
*terraform init* will download plugins and modules to that directory.

This is recommended as this will avoid having many many copies of the Provider in *.terraform* littered across all labs directories for each user.

Add the line ```export TF_DATA_DIR=~/dot.terraform``` to ~/.bashrc
and ```source ~/.bashrc```



![](/images/ThinPurpleBar.png)


# 2.1 Create the Terraform configuration

### 1. Make a directory called ‘labs’ underneath the home directory.
### 2. Change into the directory.
### 3. Make a directory called lab2, change to that directory



```bash
mkdir -p ~/labs/lab2
cd       ~/labs/lab2
# Code-Cell[8] In[4]

```

![](/images/TF-Azure_Labs_png/Azure_Lab2_Concepts_1.png)

We will follow a **best practice** of splitting up our Terraform configuration across several files.

There are no rules about how to split across several files, nor about file naming - but conventions of separating
- providers into a providers.tf file
- resources into a main.tf or resources.tf file
- variables into a vars.tf or variables.tf file
- outputs   into a outputs.tf file

In larger more complicated configurations you may want to further sub-divide resources - we might have separate files such as resources-vms.tf and resources-containers.tf for example, or use modules which we will cover later.



![](/images/ThinPurpleBar.png)


## 2.1.1 Create the provider.tf file


Create a new file **provider.tf** with the following content:
```txt
provider "azurerm" {
  features {}
  # subscription_id = "xxxx-xxxx-xxxx"
}

```




![](/images/ThinPurpleBar.png)


## 2.1.2 Create the main.tf file

This file will contain the above mentioned resources with the goal of providing us a Azure Linux VM which we can access over the internet.

<p style="display: inline-block; border-width:3px; border-style:solid; border-color:#0000AA; background-color: #ffffff; border-radius: 15px; padding: 1em;"><b>Note: </b> we will create an ssh key to be able to connect to the Virtual Machine.  From the Linux bastion VM you can create a key as follows:
</p>


``` ssh-keygen -N '' -t rsa -f ~/.ssh/id_rsa```

<p style="display: inline-block; border-width:3px; border-style:solid; border-color:#0000AA; background-color: #ffffff; border-radius: 15px; padding: 1em;"><b>Note: </b> it is also possible to reuse an existing key, or to generate a new key using Terraform
</p>


<p style="display: inline-block; border-width:3px; border-style:solid; border-color:#0000AA; background-color: #ffffff; border-radius: 15px; padding: 1em;"><b>Note: </b> Azure does not support ed25519 keys, so we use rsa</p>



Create a new file **main.tf** with the following content:
```txt

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.rg_prefix}-${var.virtual_network_name}"
  location            = var.location
  address_space       = [ var.address_space ]
  resource_group_name = var.resource_group

  tags = { source = "terraform" }
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.rg_prefix}subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group
  address_prefixes     = [ var.subnet_prefix ]

  # Curiously this resource does not have a tags parameter
  # tags = { source = "terraform" }
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.rg_prefix}nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "${var.rg_prefix}ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }

  tags = { source = "terraform" }
}

resource "azurerm_public_ip" "pip" {
  name                         = "${var.rg_prefix}-ip"
  location                     = var.location
  resource_group_name          = var.resource_group
  allocation_method            = "Dynamic"
  domain_name_label            = var.dns_name

  tags = { source = "terraform" }
}

resource "azurerm_storage_account" "stor" {
  name                     = "${var.dns_name}storage"
  location                 = var.location
  resource_group_name      = var.resource_group
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type

  tags = { source = "terraform" }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${var.rg_prefix}vm"
  location              = var.location
  resource_group_name   = var.resource_group
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

  # REMOVED - due to apparent TF/azurerm bug on storage_account:
  #boot_diagnostics {
  #  storage_account_uri = azurerm_storage_account.stor.primary_blob_endpoint
  #}
  tags = { source = "terraform" }
}

```




![](/images/ThinPurpleBar.png)


## 2.1.3 Create the outputs.tf file

We will create Terraform outputs to inform us of how we can connect to the VM to be created

Create a new file **outputs.tf** with the following content:
```txt
locals {
  fqdn = azurerm_public_ip.pip.fqdn
  user = var.admin_username
}

output "hostname" {
  value = var.hostname
}

output "vm_fqdn" {
  value = local.fqdn
}

output "vm_ip" {
  value = local.ip
}

output "ssh_command" {
  value = "ssh -i ${var.admin_priv_key} ${local.user}@${local.fqdn}"
}

output "example_ssh_command" {
  value =  "ssh -i ${var.admin_priv_key} ${local.user}@${local.fqdn} 'echo $(id -un)@$(hostname): $(hostname -i) $(uptime)'"
}

```




![](/images/ThinPurpleBar.png)


## 2.1.4 Create the variables.tf

We will define our variables for our config here, but the actual values to assign to those variables will be set in a separate file - **terraform.tfvars**


Create a new file **variables.tf** with the following content:
```txt
variable "resource_group" {
  description = "The name of the resource group in which to create the virtual network."
  default     = "terraform-training"
}
variable "rg_prefix" {
  description = "The shortened abbreviation to represent your resource group that will go on the front of some resources."
  default     = "rg"
}
variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = "southcentralus"
}

variable "hostname" {
  description = "VM name referenced also in storage-related names."
}
variable "dns_name" {
  description = " Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
}

variable "virtual_network_name" {
  description = "The name for the virtual network."
}
variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
}
variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.10.0/24"
}

variable "storage_account_tier" {
  description = "Defines the Tier of storage account to be created. Valid options are Standard and Premium."
}
variable "storage_replication_type" {
  description = "Defines the Replication Type to use for this storage account. Valid options include LRS, GRS etc."
}
variable "vm_size" {
  description = "Specifies the size of the virtual machine."
}
variable "image_publisher" {
  description = "name of the publisher of the image (az vm image list)"
}
variable "image_offer" {
  description = "the name of the offer (az vm image list)"
}
variable "image_sku" {
  description = "image sku to apply (az vm image list)"
}
variable "image_version" {
  description = "version of the image to apply (az vm image list)"
}
variable "admin_username" {
  description = "administrator user name"
}
variable "admin_priv_key" {
  description = "administrator private key (recommended to disable password auth)"
}

```




![](/images/ThinPurpleBar.png)


## 2.1.5 Create the terraform.tfvars

Terraform will look to see if there is a **terraform.tfvars** file or files matching the pattern ***.auto.tfvars** and will read the **key=value** pairs to assign values to the variables.

<p style="display: inline-block; border-width:3px; border-style:solid; border-color:#0000AA; background-color: #ffffff; border-radius: 15px; padding: 1em;"><b>Note: </b> remember to set the **resource_group** and **dns** values to your resource_group, e.g. **student1**, **student2**, ...
</p>


<p style="display: inline-block; border-width:3px; border-style:solid; border-color:#0000AA; background-color: #ffffff; border-radius: 15px; padding: 1em;"><b>Note: </b> All variables **must** have been defined already in the configuration - by convention in a **variables.tf** file (but they could be defined in any ***.tf** file).
</p>


<p style="display: inline-block; border-width:3px; border-style:solid; border-color:#0000AA; background-color: #ffffff; border-radius: 15px; padding: 1em;"><b>Note: </b> If any variables defined do not have a **default** value or are not assigned a value in a ***.tfvars** file then you will be prompted for a value when performing a **terraform plan*** or a **terraform apply**
</p>



Create a new file **terraform.tfvars** with the following content:
```txt

# Set these variables to your 'unique' resource_group:
resource_group = "student"
# Note: upper-case characters not allowed here:
dns_name       = "student"

rg_prefix = "terraform-linux-vms-linux"
location  = "eastus"

hostname  = "vm-linux-docker"

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

admin_username  = "vmadmin"

# Set this value to the ssh key generated earlier, or your own key:
admin_priv_key  = "~/.ssh/id_rsa"


```




![](/images/ThinPurpleBar.png)


# 2.1.6 Create the ssh.tf file

This file will be used to automatically generate an **ssh_config** file as ```~/.ssh/config``` on the machine from where terraform is run.

This part of the configuration will use terraform's string templating capability which we will cover later.

This will simplify connecting to the VM using ssh, without having to specify the user, the key, the DNS name or ip address at each connection.


Create a new file **ssh.tf** with the following content:
```txt

locals {
  ip = azurerm_linux_virtual_machine.vm.public_ip_address
}

locals {
  ssh_config = templatefile("${path.module}/templates/ssh.tpl", {
      node_fqdns = [ local.fqdn ]
      node_names = [ var.hostname ]
      node_ips   = [ local.ip ]
      user       = var.admin_username,
      #key_file   = format("%s/%s", path.cwd, var.admin_priv_key)
      key_file   = var.admin_priv_key
  })

}

resource "local_file" "ssh_config" {
    content = local.ssh_config
    #filename  = format("%s/ssh_config", path.cwd)
    filename  = pathexpand("~/.ssh/config")
}


```




![](/images/ThinPurpleBar.png)


# 2.1.7 Create the templates/ssh.tpl file

This file is the template file used by ssh.tf to create the **ssh_config**.

Terraform's string templating capability which we will cover later.

Place the file under the templates directory


```bash
mkdir -p templates


%{ for index, node in node_names ~}

# ${node_fqdns[index]}:
Host ${node}
    Hostname      ${node_ips[index]}
    User          ${user}
    IdentityFile  ${key_file}

%{ endfor ~}

EOF
# Code-Cell[24] In[13]

```



![](/images/ThinPurpleBar.png)


## 2.1.8 terraform fmt

Note that you can also use the **terraform fmt** command to *prettify* your code - by setting indentation correctly.

This will not make corrections, it will just apply a consistent indentation in the config files.

The command lists the Terraform files it modifies.


```bash
terraform fmt
# Code-Cell[26] In[14]

```

    main.tf
    outputs.tf
    ssh.tf
    terraform.tfvars




![](/images/ThinPurpleBar.png)


# 2.2 Create the resources



![](/images/ThinPurpleBar.png)


## 2.2.1 terraform init

We are now working in a new configuration directory and so we need to start by performing a **terraform init**.

If **TF_DATA_DIR** is set correctly then the ```Azure Provider``` which was downloaded earlier will be reused saving disk space.

<p style="display: inline-block; border-width:3px; border-style:solid; border-color:#0000AA; background-color: #ffffff; border-radius: 15px; padding: 1em;"><b>Note: </b> It is possible to upgrade any Providers or Modules specified in the config by using the <b>terraform init --upgrade</b> command.  You can run and rerun this command multiple times without creating any problems.
</p>


<p style="display: inline-block; border-width:3px; border-style:solid; border-color:#0000AA; background-color: #ffffff; border-radius: 15px; padding: 1em;"><b>Note: </b> You can see the extra options available for the init sub-command by typing <i>terraform init --help</i>
</p>




```bash
terraform init --upgrade
# Code-Cell[28] In[15]

```

    
    Initializing the backend...
    
    Initializing provider plugins...
    - Finding latest version of hashicorp/azurerm...
    - Finding latest version of hashicorp/local...
    - Using previously-installed hashicorp/local v2.4.0
    - Using previously-installed hashicorp/azurerm v3.70.0
    
    Terraform has been successfully initialized!
    
    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.
    
    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.




![](/images/ThinPurpleBar.png)


# 2.2.2 terraform plan

We will perform the terraform plan to verify what resources will be created.

This is always a good practice especially for existing configurations where there is a risk that resources will be deleted by a terraform apply !!

Terraform plan also initially performs a ```terraform validate``` to make some syntax and other checks on the configuration.


```bash
terraform plan 
# Code-Cell[30] In[16]

```

    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      + create
    
    Terraform will perform the following actions:
    
      # azurerm_linux_virtual_machine.vm will be created
      + resource "azurerm_linux_virtual_machine" "vm" {
          + admin_username                                         = "vmadmin"
          + allow_extension_operations                             = true
          + bypass_platform_safety_checks_on_user_schedule_enabled = false
          + computer_name                                          = "vm-linux-docker"
          + disable_password_authentication                        = true
          + extensions_time_budget                                 = "PT1H30M"
          + id                                                     = (known after apply)
          + location                                               = "eastus"
          + max_bid_price                                          = -1
          + name                                                   = "terraform-linux-vms-linuxvm"
          + network_interface_ids                                  = (known after apply)
          + patch_assessment_mode                                  = "ImageDefault"
          + patch_mode                                             = "ImageDefault"
          + platform_fault_domain                                  = -1
          + priority                                               = "Regular"
          + private_ip_address                                     = (known after apply)
          + private_ip_addresses                                   = (known after apply)
          + provision_vm_agent                                     = true
          + public_ip_address                                      = (known after apply)
          + public_ip_addresses                                    = (known after apply)
          + resource_group_name                                    = "student20"
          + size                                                   = "Standard_D2s_v3"
          + tags                                                   = {
              + "source" = "terraform"
            }
          + virtual_machine_id                                     = (known after apply)
    
          + admin_ssh_key {
              + public_key = <<-EOT
                    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCo2E19XSJldEdbIZ6lO8GC2DECsf9VaxkOBsJpVCZE4XIyKQDhVE/YF4Ok0bpeNq10dCzQgwN5fnQAZ4onm7ym1WmEUnmLSQIcNUKxVJvJ0MlSGbbtFYr6IR2Og6WFKDA1tMbJGVb2SxY8kleDi55LdPkNBPdov5nuAzGtm8bIeXOeATnw/VzCcREHSfj0vZWyohBhPtNTQHmxYhYKAxE5lS7ucdJigF0Nf115mcBFFPDg3yJo62JJkLeIRDrvgNBUEbrUIT9PJNdZwFhVGHFGQVxm0L5bXETuaMEhyNcoOesmpg66k7H1T80gc5A6F/a8vSrcZCOuJjNAj/nByYcKffqXc9xMIf1oD1b/dDiardFgbPFA1q84HO2k2bYjA/zjduC9YnzOyNptMyOfXEi1urGBaxrlD3zwH7Mu7tUxsK96LH8yQVf8N+NJocJa5wPfWHV+/3B8N7CBiZOkWXv/u7xpYX0a1a4Tk0fFAlN6wEGaHlUArS8sOvOF2l8ZmK8= student@cp
                EOT
              + username   = "vmadmin"
            }
    
          + os_disk {
              + caching                   = "ReadWrite"
              + disk_size_gb              = (known after apply)
              + name                      = "vm-linux-docker-osdisk"
              + storage_account_type      = "Standard_LRS"
              + write_accelerator_enabled = false
            }
    
          + source_image_reference {
              + offer     = "0001-com-ubuntu-confidential-vm-focal"
              + publisher = "Canonical"
              + sku       = "20_04-lts-cvm"
              + version   = "20.04.202306140"
            }
        }
    
      # azurerm_network_interface.nic will be created
      + resource "azurerm_network_interface" "nic" {
          + applied_dns_servers           = (known after apply)
          + dns_servers                   = (known after apply)
          + enable_accelerated_networking = false
          + enable_ip_forwarding          = false
          + id                            = (known after apply)
          + internal_dns_name_label       = (known after apply)
          + internal_domain_name_suffix   = (known after apply)
          + location                      = "eastus"
          + mac_address                   = (known after apply)
          + name                          = "terraform-linux-vms-linuxnic"
          + private_ip_address            = (known after apply)
          + private_ip_addresses          = (known after apply)
          + resource_group_name           = "student20"
          + tags                          = {
              + "source" = "terraform"
            }
          + virtual_machine_id            = (known after apply)
    
          + ip_configuration {
              + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
              + name                                               = "terraform-linux-vms-linuxipconfig"
              + primary                                            = (known after apply)
              + private_ip_address                                 = (known after apply)
              + private_ip_address_allocation                      = "Dynamic"
              + private_ip_address_version                         = "IPv4"
              + public_ip_address_id                               = (known after apply)
              + subnet_id                                          = (known after apply)
            }
        }
    
      # azurerm_public_ip.pip will be created
      + resource "azurerm_public_ip" "pip" {
          + allocation_method       = "Dynamic"
          + ddos_protection_mode    = "VirtualNetworkInherited"
          + domain_name_label       = "student20"
          + fqdn                    = (known after apply)
          + id                      = (known after apply)
          + idle_timeout_in_minutes = 4
          + ip_address              = (known after apply)
          + ip_version              = "IPv4"
          + location                = "eastus"
          + name                    = "terraform-linux-vms-linux-ip"
          + resource_group_name     = "student20"
          + sku                     = "Basic"
          + sku_tier                = "Regional"
          + tags                    = {
              + "source" = "terraform"
            }
        }
    
      # azurerm_storage_account.stor will be created
      + resource "azurerm_storage_account" "stor" {
          + access_tier                       = (known after apply)
          + account_kind                      = "StorageV2"
          + account_replication_type          = "LRS"
          + account_tier                      = "Standard"
          + allow_nested_items_to_be_public   = true
          + cross_tenant_replication_enabled  = true
          + default_to_oauth_authentication   = false
          + enable_https_traffic_only         = true
          + id                                = (known after apply)
          + infrastructure_encryption_enabled = false
          + is_hns_enabled                    = false
          + large_file_share_enabled          = (known after apply)
          + location                          = "eastus"
          + min_tls_version                   = "TLS1_2"
          + name                              = "student20storage"
          + nfsv3_enabled                     = false
          + primary_access_key                = (sensitive value)
          + primary_blob_connection_string    = (sensitive value)
          + primary_blob_endpoint             = (known after apply)
          + primary_blob_host                 = (known after apply)
          + primary_connection_string         = (sensitive value)
          + primary_dfs_endpoint              = (known after apply)
          + primary_dfs_host                  = (known after apply)
          + primary_file_endpoint             = (known after apply)
          + primary_file_host                 = (known after apply)
          + primary_location                  = (known after apply)
          + primary_queue_endpoint            = (known after apply)
          + primary_queue_host                = (known after apply)
          + primary_table_endpoint            = (known after apply)
          + primary_table_host                = (known after apply)
          + primary_web_endpoint              = (known after apply)
          + primary_web_host                  = (known after apply)
          + public_network_access_enabled     = true
          + queue_encryption_key_type         = "Service"
          + resource_group_name               = "student20"
          + secondary_access_key              = (sensitive value)
          + secondary_blob_connection_string  = (sensitive value)
          + secondary_blob_endpoint           = (known after apply)
          + secondary_blob_host               = (known after apply)
          + secondary_connection_string       = (sensitive value)
          + secondary_dfs_endpoint            = (known after apply)
          + secondary_dfs_host                = (known after apply)
          + secondary_file_endpoint           = (known after apply)
          + secondary_file_host               = (known after apply)
          + secondary_location                = (known after apply)
          + secondary_queue_endpoint          = (known after apply)
          + secondary_queue_host              = (known after apply)
          + secondary_table_endpoint          = (known after apply)
          + secondary_table_host              = (known after apply)
          + secondary_web_endpoint            = (known after apply)
          + secondary_web_host                = (known after apply)
          + sftp_enabled                      = false
          + shared_access_key_enabled         = true
          + table_encryption_key_type         = "Service"
          + tags                              = {
              + "source" = "terraform"
            }
        }
    
      # azurerm_subnet.subnet will be created
      + resource "azurerm_subnet" "subnet" {
          + address_prefixes                               = [
              + "10.0.10.0/24",
            ]
          + enforce_private_link_endpoint_network_policies = (known after apply)
          + enforce_private_link_service_network_policies  = (known after apply)
          + id                                             = (known after apply)
          + name                                           = "terraform-linux-vms-linuxsubnet"
          + private_endpoint_network_policies_enabled      = (known after apply)
          + private_link_service_network_policies_enabled  = (known after apply)
          + resource_group_name                            = "student20"
          + virtual_network_name                           = "terraform-linux-vms-linux-terraform-vnet"
        }
    
      # azurerm_virtual_network.vnet will be created
      + resource "azurerm_virtual_network" "vnet" {
          + address_space       = [
              + "10.0.0.0/16",
            ]
          + dns_servers         = (known after apply)
          + guid                = (known after apply)
          + id                  = (known after apply)
          + location            = "eastus"
          + name                = "terraform-linux-vms-linux-terraform-vnet"
          + resource_group_name = "student20"
          + subnet              = (known after apply)
          + tags                = {
              + "source" = "terraform"
            }
        }
    
      # local_file.ssh_config will be created
      + resource "local_file" "ssh_config" {
          + content              = (known after apply)
          + content_base64sha256 = (known after apply)
          + content_base64sha512 = (known after apply)
          + content_md5          = (known after apply)
          + content_sha1         = (known after apply)
          + content_sha256       = (known after apply)
          + content_sha512       = (known after apply)
          + directory_permission = "0777"
          + file_permission      = "0777"
          + filename             = "/home/student/.ssh/config"
          + id                   = (known after apply)
        }
    
    Plan: 7 to add, 0 to change, 0 to destroy.
    
    Changes to Outputs:
      + example_ssh_command = (known after apply)
      + hostname            = "vm-linux-docker"
      + ssh_command         = (known after apply)
      + vm_fqdn             = (known after apply)
      + vm_ip               = (known after apply)
    
    ───────────────────────────────────────────────────────────────────────────────
    
    Note: You didn't use the -out option to save this plan, so Terraform can't
    guarantee to take exactly these actions if you run "terraform apply" now.




![](/images/ThinPurpleBar.png)


## Experimenting with variables

So far we have not created any resources, we have just executed a plan to see what
resources would be created/changed/destroyed if the plan is applied.

Edit the ```terraform.tfvars``` line, replacing:
```
    hostname  = "vm-linux-docker"
````
by
```
    #hostname  = "vm-linux-docker"
```

to comment out the ```hostname``` value.

Now rerun the ```terraform plan``` and observe that you are prompted to provide a value
for hostname
- because no ```default value``` is declared in variables.tf
- the prompt is the description you used for the variable in variables.tf


**Note**: alternatively we could have invoked terraform as, ```terraform plan -var hostname=test-vm```, passing in the variable value


### Terraform plan actions

```Terraform plan``` will
- first examine the state of the components managed by this Terraform workspace - as defined in your ```*.tf``` configuration
- update the ```terraform.tfstate``` file to represent this actual state.
- compare the configuration which represents the *desired state* with the *actual state*
- build the plan of changes to make (when applied)
- show a summary of changes to make
- It will **not apply** or make any changes

#### Saving the plan as a binary file

We can re-run the plan command as many times as we like, it will always compare the current state of the system with your configuration.

We can also save the output using the *-out* option, e.g. as


```bash
terraform plan -out plan.out
# Code-Cell[33] In[17]

```

    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      + create
    
    Terraform will perform the following actions:
    
      # azurerm_linux_virtual_machine.vm will be created
      + resource "azurerm_linux_virtual_machine" "vm" {
          + admin_username                                         = "vmadmin"
          + allow_extension_operations                             = true
          + bypass_platform_safety_checks_on_user_schedule_enabled = false
          + computer_name                                          = "vm-linux-docker"
          + disable_password_authentication                        = true
          + extensions_time_budget                                 = "PT1H30M"
          + id                                                     = (known after apply)
          + location                                               = "eastus"
          + max_bid_price                                          = -1
          + name                                                   = "terraform-linux-vms-linuxvm"
          + network_interface_ids                                  = (known after apply)
          + patch_assessment_mode                                  = "ImageDefault"
          + patch_mode                                             = "ImageDefault"
          + platform_fault_domain                                  = -1
          + priority                                               = "Regular"
          + private_ip_address                                     = (known after apply)
          + private_ip_addresses                                   = (known after apply)
          + provision_vm_agent                                     = true
          + public_ip_address                                      = (known after apply)
          + public_ip_addresses                                    = (known after apply)
          + resource_group_name                                    = "student20"
          + size                                                   = "Standard_D2s_v3"
          + tags                                                   = {
              + "source" = "terraform"
            }
          + virtual_machine_id                                     = (known after apply)
    
          + admin_ssh_key {
              + public_key = <<-EOT
                    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCo2E19XSJldEdbIZ6lO8GC2DECsf9VaxkOBsJpVCZE4XIyKQDhVE/YF4Ok0bpeNq10dCzQgwN5fnQAZ4onm7ym1WmEUnmLSQIcNUKxVJvJ0MlSGbbtFYr6IR2Og6WFKDA1tMbJGVb2SxY8kleDi55LdPkNBPdov5nuAzGtm8bIeXOeATnw/VzCcREHSfj0vZWyohBhPtNTQHmxYhYKAxE5lS7ucdJigF0Nf115mcBFFPDg3yJo62JJkLeIRDrvgNBUEbrUIT9PJNdZwFhVGHFGQVxm0L5bXETuaMEhyNcoOesmpg66k7H1T80gc5A6F/a8vSrcZCOuJjNAj/nByYcKffqXc9xMIf1oD1b/dDiardFgbPFA1q84HO2k2bYjA/zjduC9YnzOyNptMyOfXEi1urGBaxrlD3zwH7Mu7tUxsK96LH8yQVf8N+NJocJa5wPfWHV+/3B8N7CBiZOkWXv/u7xpYX0a1a4Tk0fFAlN6wEGaHlUArS8sOvOF2l8ZmK8= student@cp
                EOT
              + username   = "vmadmin"
            }
    
          + os_disk {
              + caching                   = "ReadWrite"
              + disk_size_gb              = (known after apply)
              + name                      = "vm-linux-docker-osdisk"
              + storage_account_type      = "Standard_LRS"
              + write_accelerator_enabled = false
            }
    
          + source_image_reference {
              + offer     = "0001-com-ubuntu-confidential-vm-focal"
              + publisher = "Canonical"
              + sku       = "20_04-lts-cvm"
              + version   = "20.04.202306140"
            }
        }
    
      # azurerm_network_interface.nic will be created
      + resource "azurerm_network_interface" "nic" {
          + applied_dns_servers           = (known after apply)
          + dns_servers                   = (known after apply)
          + enable_accelerated_networking = false
          + enable_ip_forwarding          = false
          + id                            = (known after apply)
          + internal_dns_name_label       = (known after apply)
          + internal_domain_name_suffix   = (known after apply)
          + location                      = "eastus"
          + mac_address                   = (known after apply)
          + name                          = "terraform-linux-vms-linuxnic"
          + private_ip_address            = (known after apply)
          + private_ip_addresses          = (known after apply)
          + resource_group_name           = "student20"
          + tags                          = {
              + "source" = "terraform"
            }
          + virtual_machine_id            = (known after apply)
    
          + ip_configuration {
              + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
              + name                                               = "terraform-linux-vms-linuxipconfig"
              + primary                                            = (known after apply)
              + private_ip_address                                 = (known after apply)
              + private_ip_address_allocation                      = "Dynamic"
              + private_ip_address_version                         = "IPv4"
              + public_ip_address_id                               = (known after apply)
              + subnet_id                                          = (known after apply)
            }
        }
    
      # azurerm_public_ip.pip will be created
      + resource "azurerm_public_ip" "pip" {
          + allocation_method       = "Dynamic"
          + ddos_protection_mode    = "VirtualNetworkInherited"
          + domain_name_label       = "student20"
          + fqdn                    = (known after apply)
          + id                      = (known after apply)
          + idle_timeout_in_minutes = 4
          + ip_address              = (known after apply)
          + ip_version              = "IPv4"
          + location                = "eastus"
          + name                    = "terraform-linux-vms-linux-ip"
          + resource_group_name     = "student20"
          + sku                     = "Basic"
          + sku_tier                = "Regional"
          + tags                    = {
              + "source" = "terraform"
            }
        }
    
      # azurerm_storage_account.stor will be created
      + resource "azurerm_storage_account" "stor" {
          + access_tier                       = (known after apply)
          + account_kind                      = "StorageV2"
          + account_replication_type          = "LRS"
          + account_tier                      = "Standard"
          + allow_nested_items_to_be_public   = true
          + cross_tenant_replication_enabled  = true
          + default_to_oauth_authentication   = false
          + enable_https_traffic_only         = true
          + id                                = (known after apply)
          + infrastructure_encryption_enabled = false
          + is_hns_enabled                    = false
          + large_file_share_enabled          = (known after apply)
          + location                          = "eastus"
          + min_tls_version                   = "TLS1_2"
          + name                              = "student20storage"
          + nfsv3_enabled                     = false
          + primary_access_key                = (sensitive value)
          + primary_blob_connection_string    = (sensitive value)
          + primary_blob_endpoint             = (known after apply)
          + primary_blob_host                 = (known after apply)
          + primary_connection_string         = (sensitive value)
          + primary_dfs_endpoint              = (known after apply)
          + primary_dfs_host                  = (known after apply)
          + primary_file_endpoint             = (known after apply)
          + primary_file_host                 = (known after apply)
          + primary_location                  = (known after apply)
          + primary_queue_endpoint            = (known after apply)
          + primary_queue_host                = (known after apply)
          + primary_table_endpoint            = (known after apply)
          + primary_table_host                = (known after apply)
          + primary_web_endpoint              = (known after apply)
          + primary_web_host                  = (known after apply)
          + public_network_access_enabled     = true
          + queue_encryption_key_type         = "Service"
          + resource_group_name               = "student20"
          + secondary_access_key              = (sensitive value)
          + secondary_blob_connection_string  = (sensitive value)
          + secondary_blob_endpoint           = (known after apply)
          + secondary_blob_host               = (known after apply)
          + secondary_connection_string       = (sensitive value)
          + secondary_dfs_endpoint            = (known after apply)
          + secondary_dfs_host                = (known after apply)
          + secondary_file_endpoint           = (known after apply)
          + secondary_file_host               = (known after apply)
          + secondary_location                = (known after apply)
          + secondary_queue_endpoint          = (known after apply)
          + secondary_queue_host              = (known after apply)
          + secondary_table_endpoint          = (known after apply)
          + secondary_table_host              = (known after apply)
          + secondary_web_endpoint            = (known after apply)
          + secondary_web_host                = (known after apply)
          + sftp_enabled                      = false
          + shared_access_key_enabled         = true
          + table_encryption_key_type         = "Service"
          + tags                              = {
              + "source" = "terraform"
            }
        }
    
      # azurerm_subnet.subnet will be created
      + resource "azurerm_subnet" "subnet" {
          + address_prefixes                               = [
              + "10.0.10.0/24",
            ]
          + enforce_private_link_endpoint_network_policies = (known after apply)
          + enforce_private_link_service_network_policies  = (known after apply)
          + id                                             = (known after apply)
          + name                                           = "terraform-linux-vms-linuxsubnet"
          + private_endpoint_network_policies_enabled      = (known after apply)
          + private_link_service_network_policies_enabled  = (known after apply)
          + resource_group_name                            = "student20"
          + virtual_network_name                           = "terraform-linux-vms-linux-terraform-vnet"
        }
    
      # azurerm_virtual_network.vnet will be created
      + resource "azurerm_virtual_network" "vnet" {
          + address_space       = [
              + "10.0.0.0/16",
            ]
          + dns_servers         = (known after apply)
          + guid                = (known after apply)
          + id                  = (known after apply)
          + location            = "eastus"
          + name                = "terraform-linux-vms-linux-terraform-vnet"
          + resource_group_name = "student20"
          + subnet              = (known after apply)
          + tags                = {
              + "source" = "terraform"
            }
        }
    
      # local_file.ssh_config will be created
      + resource "local_file" "ssh_config" {
          + content              = (known after apply)
          + content_base64sha256 = (known after apply)
          + content_base64sha512 = (known after apply)
          + content_md5          = (known after apply)
          + content_sha1         = (known after apply)
          + content_sha256       = (known after apply)
          + content_sha512       = (known after apply)
          + directory_permission = "0777"
          + file_permission      = "0777"
          + filename             = "/home/student/.ssh/config"
          + id                   = (known after apply)
        }
    
    Plan: 7 to add, 0 to change, 0 to destroy.
    
    Changes to Outputs:
      + example_ssh_command = (known after apply)
      + hostname            = "vm-linux-docker"
      + ssh_command         = (known after apply)
      + vm_fqdn             = (known after apply)
      + vm_ip               = (known after apply)
    
    ───────────────────────────────────────────────────────────────────────────────
    
    Saved the plan to: plan.out
    
    To perform exactly these actions, run the following command to apply:
        terraform apply "plan.out"


The plan.out file can be passed as a parameter to the ```terraform apply```.

#### Reviewing the plan output

It is important to know when deploying real infrastructure what changes are to be made, the summary line can be a quick indicator that something might not be as you expect.

Terraform plan will output a *summary line*:

```Plan: 7 to add, 0 to change, 0 to destroy.```

We can see very clearly a summary of how many resources will be created, modified or destroyed.


When in production, a line of the form

```Plan: 0 to add, 10 to change, **31 to destroy**```

might make you **think twice!!**

Pay attention to this line before performing an apply !

<p style="display: inline-block; border-width:3px; border-style:solid; border-color:#0000AA; background-color: #ffffff; border-radius: 15px; padding: 1em;"><b>Note: </b> But don't worry a <b>terraform plan</b> is safe and will not apply any changes.
</p>





![](/images/ThinPurpleBar.png)


## Uncomment the hostname line in terraform.tfvars

Now uncomment the line so that we use the correct value



![](/images/ThinPurpleBar.png)


# 2.2.3 terraform apply

If the plan goes well as above we can see that 8 new resources will be created allowing our VM to be created.

**Note**: We could also use the plan.out file we created earlier using the command *terraform apply plan.out*

**Warning**: The plan.out file will only be valid until the next state-modification, i.e. ```terraform apply``` or ```terraform destroy```.  After such a command the plan.out file should not be reused as it is no longer valid - terraform *should* detect this and refuse to apply the plan.

The *apply* will first build a *plan*, unless a plan file was provided

It will then inform you of the changes to be made, with a *summary line* as before, but this time you will be asked if you want to apply the changes.

Let's go ahead and apply the config


```bash
terraform apply 
# Code-Cell[37] In[18]

```

    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      + create
    
    Terraform will perform the following actions:
    
      # azurerm_linux_virtual_machine.vm will be created
      + resource "azurerm_linux_virtual_machine" "vm" {
          + admin_username                                         = "vmadmin"
          + allow_extension_operations                             = true
          + bypass_platform_safety_checks_on_user_schedule_enabled = false
          + computer_name                                          = "vm-linux-docker"
          + disable_password_authentication                        = true
          + extensions_time_budget                                 = "PT1H30M"
          + id                                                     = (known after apply)
          + location                                               = "eastus"
          + max_bid_price                                          = -1
          + name                                                   = "terraform-linux-vms-linuxvm"
          + network_interface_ids                                  = (known after apply)
          + patch_assessment_mode                                  = "ImageDefault"
          + patch_mode                                             = "ImageDefault"
          + platform_fault_domain                                  = -1
          + priority                                               = "Regular"
          + private_ip_address                                     = (known after apply)
          + private_ip_addresses                                   = (known after apply)
          + provision_vm_agent                                     = true
          + public_ip_address                                      = (known after apply)
          + public_ip_addresses                                    = (known after apply)
          + resource_group_name                                    = "student20"
          + size                                                   = "Standard_D2s_v3"
          + tags                                                   = {
              + "source" = "terraform"
            }
          + virtual_machine_id                                     = (known after apply)
    
          + admin_ssh_key {
              + public_key = <<-EOT
                    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCo2E19XSJldEdbIZ6lO8GC2DECsf9VaxkOBsJpVCZE4XIyKQDhVE/YF4Ok0bpeNq10dCzQgwN5fnQAZ4onm7ym1WmEUnmLSQIcNUKxVJvJ0MlSGbbtFYr6IR2Og6WFKDA1tMbJGVb2SxY8kleDi55LdPkNBPdov5nuAzGtm8bIeXOeATnw/VzCcREHSfj0vZWyohBhPtNTQHmxYhYKAxE5lS7ucdJigF0Nf115mcBFFPDg3yJo62JJkLeIRDrvgNBUEbrUIT9PJNdZwFhVGHFGQVxm0L5bXETuaMEhyNcoOesmpg66k7H1T80gc5A6F/a8vSrcZCOuJjNAj/nByYcKffqXc9xMIf1oD1b/dDiardFgbPFA1q84HO2k2bYjA/zjduC9YnzOyNptMyOfXEi1urGBaxrlD3zwH7Mu7tUxsK96LH8yQVf8N+NJocJa5wPfWHV+/3B8N7CBiZOkWXv/u7xpYX0a1a4Tk0fFAlN6wEGaHlUArS8sOvOF2l8ZmK8= student@cp
                EOT
              + username   = "vmadmin"
            }
    
          + os_disk {
              + caching                   = "ReadWrite"
              + disk_size_gb              = (known after apply)
              + name                      = "vm-linux-docker-osdisk"
              + storage_account_type      = "Standard_LRS"
              + write_accelerator_enabled = false
            }
    
          + source_image_reference {
              + offer     = "0001-com-ubuntu-confidential-vm-focal"
              + publisher = "Canonical"
              + sku       = "20_04-lts-cvm"
              + version   = "20.04.202306140"
            }
        }
    
      # azurerm_network_interface.nic will be created
      + resource "azurerm_network_interface" "nic" {
          + applied_dns_servers           = (known after apply)
          + dns_servers                   = (known after apply)
          + enable_accelerated_networking = false
          + enable_ip_forwarding          = false
          + id                            = (known after apply)
          + internal_dns_name_label       = (known after apply)
          + internal_domain_name_suffix   = (known after apply)
          + location                      = "eastus"
          + mac_address                   = (known after apply)
          + name                          = "terraform-linux-vms-linuxnic"
          + private_ip_address            = (known after apply)
          + private_ip_addresses          = (known after apply)
          + resource_group_name           = "student20"
          + tags                          = {
              + "source" = "terraform"
            }
          + virtual_machine_id            = (known after apply)
    
          + ip_configuration {
              + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
              + name                                               = "terraform-linux-vms-linuxipconfig"
              + primary                                            = (known after apply)
              + private_ip_address                                 = (known after apply)
              + private_ip_address_allocation                      = "Dynamic"
              + private_ip_address_version                         = "IPv4"
              + public_ip_address_id                               = (known after apply)
              + subnet_id                                          = (known after apply)
            }
        }
    
      # azurerm_public_ip.pip will be created
      + resource "azurerm_public_ip" "pip" {
          + allocation_method       = "Dynamic"
          + ddos_protection_mode    = "VirtualNetworkInherited"
          + domain_name_label       = "student20"
          + fqdn                    = (known after apply)
          + id                      = (known after apply)
          + idle_timeout_in_minutes = 4
          + ip_address              = (known after apply)
          + ip_version              = "IPv4"
          + location                = "eastus"
          + name                    = "terraform-linux-vms-linux-ip"
          + resource_group_name     = "student20"
          + sku                     = "Basic"
          + sku_tier                = "Regional"
          + tags                    = {
              + "source" = "terraform"
            }
        }
    
      # azurerm_storage_account.stor will be created
      + resource "azurerm_storage_account" "stor" {
          + access_tier                       = (known after apply)
          + account_kind                      = "StorageV2"
          + account_replication_type          = "LRS"
          + account_tier                      = "Standard"
          + allow_nested_items_to_be_public   = true
          + cross_tenant_replication_enabled  = true
          + default_to_oauth_authentication   = false
          + enable_https_traffic_only         = true
          + id                                = (known after apply)
          + infrastructure_encryption_enabled = false
          + is_hns_enabled                    = false
          + large_file_share_enabled          = (known after apply)
          + location                          = "eastus"
          + min_tls_version                   = "TLS1_2"
          + name                              = "student20storage"
          + nfsv3_enabled                     = false
          + primary_access_key                = (sensitive value)
          + primary_blob_connection_string    = (sensitive value)
          + primary_blob_endpoint             = (known after apply)
          + primary_blob_host                 = (known after apply)
          + primary_connection_string         = (sensitive value)
          + primary_dfs_endpoint              = (known after apply)
          + primary_dfs_host                  = (known after apply)
          + primary_file_endpoint             = (known after apply)
          + primary_file_host                 = (known after apply)
          + primary_location                  = (known after apply)
          + primary_queue_endpoint            = (known after apply)
          + primary_queue_host                = (known after apply)
          + primary_table_endpoint            = (known after apply)
          + primary_table_host                = (known after apply)
          + primary_web_endpoint              = (known after apply)
          + primary_web_host                  = (known after apply)
          + public_network_access_enabled     = true
          + queue_encryption_key_type         = "Service"
          + resource_group_name               = "student20"
          + secondary_access_key              = (sensitive value)
          + secondary_blob_connection_string  = (sensitive value)
          + secondary_blob_endpoint           = (known after apply)
          + secondary_blob_host               = (known after apply)
          + secondary_connection_string       = (sensitive value)
          + secondary_dfs_endpoint            = (known after apply)
          + secondary_dfs_host                = (known after apply)
          + secondary_file_endpoint           = (known after apply)
          + secondary_file_host               = (known after apply)
          + secondary_location                = (known after apply)
          + secondary_queue_endpoint          = (known after apply)
          + secondary_queue_host              = (known after apply)
          + secondary_table_endpoint          = (known after apply)
          + secondary_table_host              = (known after apply)
          + secondary_web_endpoint            = (known after apply)
          + secondary_web_host                = (known after apply)
          + sftp_enabled                      = false
          + shared_access_key_enabled         = true
          + table_encryption_key_type         = "Service"
          + tags                              = {
              + "source" = "terraform"
            }
        }
    
      # azurerm_subnet.subnet will be created
      + resource "azurerm_subnet" "subnet" {
          + address_prefixes                               = [
              + "10.0.10.0/24",
            ]
          + enforce_private_link_endpoint_network_policies = (known after apply)
          + enforce_private_link_service_network_policies  = (known after apply)
          + id                                             = (known after apply)
          + name                                           = "terraform-linux-vms-linuxsubnet"
          + private_endpoint_network_policies_enabled      = (known after apply)
          + private_link_service_network_policies_enabled  = (known after apply)
          + resource_group_name                            = "student20"
          + virtual_network_name                           = "terraform-linux-vms-linux-terraform-vnet"
        }
    
      # azurerm_virtual_network.vnet will be created
      + resource "azurerm_virtual_network" "vnet" {
          + address_space       = [
              + "10.0.0.0/16",
            ]
          + dns_servers         = (known after apply)
          + guid                = (known after apply)
          + id                  = (known after apply)
          + location            = "eastus"
          + name                = "terraform-linux-vms-linux-terraform-vnet"
          + resource_group_name = "student20"
          + subnet              = (known after apply)
          + tags                = {
              + "source" = "terraform"
            }
        }
    
      # local_file.ssh_config will be created
      + resource "local_file" "ssh_config" {
          + content              = (known after apply)
          + content_base64sha256 = (known after apply)
          + content_base64sha512 = (known after apply)
          + content_md5          = (known after apply)
          + content_sha1         = (known after apply)
          + content_sha256       = (known after apply)
          + content_sha512       = (known after apply)
          + directory_permission = "0777"
          + file_permission      = "0777"
          + filename             = "/home/student/.ssh/config"
          + id                   = (known after apply)
        }
    
    Plan: 7 to add, 0 to change, 0 to destroy.
    
    Changes to Outputs:
      + example_ssh_command = (known after apply)
      + hostname            = "vm-linux-docker"
      + ssh_command         = (known after apply)
      + vm_fqdn             = (known after apply)
      + vm_ip               = (known after apply)
    azurerm_public_ip.pip: Creating...
    azurerm_virtual_network.vnet: Creating...
    azurerm_storage_account.stor: Creating...
    azurerm_public_ip.pip: Creation complete after 5s [id=/subscriptions/20ab9d79-4e89-4dcd-bfd9-9535a331fb7f/resourceGroups/student20/providers/Microsoft.Network/publicIPAddresses/terraform-linux-vms-linux-ip]
    azurerm_virtual_network.vnet: Creation complete after 8s [id=/subscriptions/20ab9d79-4e89-4dcd-bfd9-9535a331fb7f/resourceGroups/student20/providers/Microsoft.Network/virtualNetworks/terraform-linux-vms-linux-terraform-vnet]
    azurerm_subnet.subnet: Creating...
    azurerm_storage_account.stor: Still creating... [10s elapsed]
    azurerm_subnet.subnet: Creation complete after 6s [id=/subscriptions/20ab9d79-4e89-4dcd-bfd9-9535a331fb7f/resourceGroups/student20/providers/Microsoft.Network/virtualNetworks/terraform-linux-vms-linux-terraform-vnet/subnets/terraform-linux-vms-linuxsubnet]
    azurerm_network_interface.nic: Creating...
    azurerm_storage_account.stor: Still creating... [21s elapsed]
    azurerm_network_interface.nic: Still creating... [10s elapsed]
    azurerm_storage_account.stor: Creation complete after 26s [id=/subscriptions/20ab9d79-4e89-4dcd-bfd9-9535a331fb7f/resourceGroups/student20/providers/Microsoft.Storage/storageAccounts/student20storage]
    azurerm_network_interface.nic: Creation complete after 14s [id=/subscriptions/20ab9d79-4e89-4dcd-bfd9-9535a331fb7f/resourceGroups/student20/providers/Microsoft.Network/networkInterfaces/terraform-linux-vms-linuxnic]
    azurerm_linux_virtual_machine.vm: Creating...
    azurerm_linux_virtual_machine.vm: Still creating... [10s elapsed]
    azurerm_linux_virtual_machine.vm: Still creating... [20s elapsed]
    azurerm_linux_virtual_machine.vm: Still creating... [30s elapsed]
    azurerm_linux_virtual_machine.vm: Still creating... [40s elapsed]
    azurerm_linux_virtual_machine.vm: Still creating... [50s elapsed]
    azurerm_linux_virtual_machine.vm: Creation complete after 53s [id=/subscriptions/20ab9d79-4e89-4dcd-bfd9-9535a331fb7f/resourceGroups/student20/providers/Microsoft.Compute/virtualMachines/terraform-linux-vms-linuxvm]
    local_file.ssh_config: Creating...
    local_file.ssh_config: Creation complete after 0s [id=be143db84dbb394cd621f639f61e7c5b21505e49]
    
    Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    example_ssh_command = "ssh -i ~/.ssh/id_rsa vmadmin@student20.eastus.cloudapp.azure.com 'echo $(id -un)@$(hostname): $(hostname -i) $(uptime)'"
    hostname = "vm-linux-docker"
    ssh_command = "ssh -i ~/.ssh/id_rsa vmadmin@student20.eastus.cloudapp.azure.com"
    vm_fqdn = "student20.eastus.cloudapp.azure.com"
    vm_ip = "20.25.90.27"




![](/images/ThinPurpleBar.png)


## 2.2.4 Post apply

Note that in the above result of the ```terraform apply``` we can see the outputs we specified in the ```outputs.tf``` file

We can also see those outputs at any time by running the ```terraform output``` command.  Note that this simply obtains the information from the terraform view of state - contained in the ```terraform.tfstate``` file currently.


```bash
ls -altr ~/labs/lab2/terraform.tfstate
# Code-Cell[39] In[19]

```

    -rw-rw-r-- 1 student student 20726 Aug 23 19:42 /home/student/labs/lab2/terraform.tfstate



```bash
terraform output
# Code-Cell[40] In[20]

```

    example_ssh_command = "ssh -i ~/.ssh/id_rsa vmadmin@student20.eastus.cloudapp.azure.com 'echo $(id -un)@$(hostname): $(hostname -i) $(uptime)'"
    hostname = "vm-linux-docker"
    ssh_command = "ssh -i ~/.ssh/id_rsa vmadmin@student20.eastus.cloudapp.azure.com"
    vm_fqdn = "student20.eastus.cloudapp.azure.com"
    vm_ip = "20.25.90.27"


We can also see that the ```ssh_config``` file was created


```bash
ls -altr ~/.ssh/config
# Code-Cell[42] In[21]

```

    -rwxrwxr-x 1 student student 154 Aug 23 19:42 /home/student/.ssh/config



```bash
cat ~/.ssh/config
# Code-Cell[43] In[22]

```

    
    
    # student20.eastus.cloudapp.azure.com:
    Host vm-linux-docker
        Hostname      20.25.90.27
        User          vmadmin
        IdentityFile  ~/.ssh/id_rsa
    
    




![](/images/ThinPurpleBar.png)


## 2.2.5 Create a graph of resources in the current config

We can generate a graphviz format file representing the graph of resources represented by the current configuration.

<p style="display: inline-block; border-width:3px; border-style:solid; border-color:#0000AA; background-color: #ffffff; border-radius: 15px; padding: 1em;"><b>Note: </b> We speak here of the configuration as represented by the group of .tf files, not the actual state
</p>


If we run the command ```terraform graph``` we will see a representation of the configuration


```bash
terraform graph | head -5
# Code-Cell[46] In[24]

```

    digraph {
    	compound = "true"
    	newrank = "true"
    	subgraph "root" {
    		"[root] azurerm_linux_virtual_machine.vm (expand)" [label = "azurerm_linux_virtual_machine.vm", shape = "box"]


We can display this graphicaly by performing the following steps:
1. install the graphviz software - on the bastion VM
2. pipe terraform graph output into the graphviz ```dot``` utility
3. Launch a web server to expose the local directory
4. Browse to the "bastion VM" on the exposed port

### Converting from graphviz format to svg

You should have graphviz installed on your machine already, check as below

If you see no output from the following command then you do not have graphviz


```bash
dpkg -l | grep graphviz | grep ^ii
# Code-Cell[49] In[25]

```

    ii  graphviz                          2.42.2-3build2                    arm64        rich set of graph drawing tools


<p style="display: inline-block; border-width:3px; border-style:solid; border-color:#0000AA; background-color: #ffffff; border-radius: 15px; padding: 1em;"><b>Note: </b> IFF graphviz is not already present, this step will require intervention from your instructor ... </p>



#### Use graphviz 'dot' utility to convert to svg


```bash
terraform graph | dot -Tsvg > graph.svg
# Code-Cell[53] In[27]

```

You should now have a graph.svg with content something like the following:


```bash
head -10 graph.svg
# Code-Cell[55] In[28]

```

    <?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"
     "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
    <!-- Generated by graphviz version 2.43.0 (0)
     -->
    <!-- Title: %3 Pages: 1 -->
    <svg width="2209pt" height="692pt"
     viewBox="0.00 0.00 2208.77 692.00" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <g id="graph0" class="graph" transform="scale(1 1) rotate(0) translate(4 688)">
    <title>%3</title>


Now we can serve this file using the command
**Note**: Choose port number 31001 if you are user1, 31002 uf you are user2 etc ...

As student20:
```
python3 -m http.server --bind 0.0.0.0 31020
```



```bash
CODE python3 -m http.server --bind 0.0.0.0 31020
sleep 2

# Code-Cell[58] In[30]

```

    python3 -m http.server --bind 0.0.0.0 31020
    [1] 1018925




With a browser navigate to http://&lt;BASTION_HOST&gt;:&lt;:PORT&gt;/graph.svg

e.g. http://bastion-ls.mjbright.click:31000/graph.svg

You should see something similar to:

<!-- <div>
    <object data="graph.svg" type="image/svg+xml">
    </object>
<img src="azure_vm_graph.svg" />
</div> -->

![](/images/azure_vm_graph.svg.png)


**Note**: You may have difficulties to view the svg, if so try with a different browser

See https://www.terraform.io/docs/commands/graph.html for more information about using the graph sub-command.

### Why displaying the graph is useful

This can be very useful to understand the configuration and in particular the dependencies between different resources

This graph is used by Terraform itself to determine in which order resources should be created/destroyed which is important when there are inter-dependencies - which is usually the case.

### Other ways of displaying the graph

#### graphvizOnline

Copy the ```terraform graph``` output and post it to the web page https://dreampuf.github.io/GraphvizOnline

#### Blast Radius

Another tool which can be used is ```blast radius``` at https://28mm.github.io/blast-radius-docs/

#### BrainBoard

Brainboard, https://www.brainboard.co, seems to be a really interesting option, but has now become a paid for service - after the 21 days free trial period.




![](/images/ThinPurpleBar.png)


# 2.3 Accessing the VM

Let us verify that we can now connect to our new VM.

We can use the ```example_ssh_command``` from our outputs to get some informative output

We can use the ```ssh_command``` to get a shell in the VM

**BUT** we also created/overwrote the ```~/.ssh/config``` file and so a simple ```ssh vm-linux-docker``` will work also


```bash
ssh vm-linux-docker uptime
# Code-Cell[64] In[32]

```

     20:43:54 up  2:56,  0 users,  load average: 0.16, 0.03, 0.01



```bash
ssh vm-linux-docker 'echo $(id -un)@$(hostname): $(hostname -i) - $(uptime)'
# Code-Cell[65] In[33]

```

    vmadmin@vm-linux-docker: 10.0.10.4 - 20:43:56 up 2:56, 0 users, load average: 0.16, 0.03, 0.01



```bash
CODE $CODE_CMD

# Code-Cell[67] In[35]

```

    ssh -i ~/.ssh/id_rsa vmadmin@student20.eastus.cloudapp.azure.com 'echo $(id -un)@$(hostname): $(hostname -i) $(uptime)'
    vmadmin@vm-linux-docker: 10.0.10.4 20:43:59 up 2:56, 0 users, load average: 0.15, 0.03, 0.01




![](/images/ThinPurpleBar.png)


# 2.4 Extending the config for Ansible

Now that we have a working configuration for a VM and can connect to it, let's extend our config to use ansible to configure the VM with Docker

![](/images/TF-Azure_Labs_png/Azure_Lab2_Concepts_2.png)




![](/images/ThinPurpleBar.png)


# 2.4.1 Create the ansible.tf file

This file will be used to automatically generate an ```ansible_inventory``` file preconfigured to connect to our VM using the provided ssh key.

This part of the configuration will use terraform's string templating capability which we will cover later.

We will be using ansible to automate installing of Docker on the created VM

Create a new file **ansible.tf** with the following content:
```txt

locals {
  ansible_hosts = templatefile("${path.module}/templates/ansible.tpl", {
      node_fqdns = [ local.fqdn ]
      node_names = [ var.hostname ]
      node_ips   = [ local.ip ]
      user       = var.admin_username,
      key_file   = var.admin_priv_key
  })
}

output ansible_hosts {
    value = local.ansible_hosts
}

resource "local_file" "ansible_inventory" {
    content   = local.ansible_hosts
    #filename  = format("%s/ansible_inventory", path.cwd)
   filename  = pathexpand("~/ansible_inventory")
}


```




![](/images/ThinPurpleBar.png)


# 2.4.2 Create the templates/ansible.tpl file

This file is the template file used by ansible.tf to create the ```ansible_inventory``` .

Terraform's string templating capability which we will cover later.

Make a new directory ```~/labs/lab2/templates``` for this file



```bash
mkdir -p templates
# Code-Cell[72] In[47]

```

Create a new file **templates/ansible.tpl** with the following content:
```txt

# https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#connecting-to-hosts-behavioral-inventory-parameters

[all]
%{ for index, node in node_names ~}
${node} ansible_host=${node_ips[index]} new_hostname=cp
%{ endfor ~}

[all:vars]
ansible_user=${user}
ansible_ssh_private_key_file=${key_file}


```




![](/images/ThinPurpleBar.png)


# 2.4.3 Re-apply the config

Now re-run the plan to check that our changes will not change/destroy any existing resources, but only create a new resource (a local_file for the ```ansible_inventory``` file)

Then apply the new config




![](/images/ThinPurpleBar.png)


## SKIP STEP 2.4.4 Install ansible and check that we can use it

We have created an ```ansible_inventory``` and we can install ansible and test connectivity to the remote machine but we will not currently use Ansible for installing Docker, we will use the provided Bash script.


```bash
sudo apt-get update
sudo apt-get install -y ansible=2.9.6+dfsg-1

# Code-Cell[77] In[51]

```

    Hit:1 http://ports.ubuntu.com/ubuntu-ports focal InRelease
    Get:2 http://ports.ubuntu.com/ubuntu-ports focal-updates InRelease [114 kB]
    Hit:3 https://download.docker.com/linux/ubuntu focal InRelease                 
    Get:4 http://ports.ubuntu.com/ubuntu-ports focal-backports InRelease [108 kB]  
    Hit:5 https://packages.microsoft.com/repos/azure-cli focal InRelease
    Get:6 http://ports.ubuntu.com/ubuntu-ports focal-security InRelease [114 kB]
    Get:7 http://ports.ubuntu.com/ubuntu-ports focal-updates/main arm64 Packages [2053 kB]
    Get:8 http://ports.ubuntu.com/ubuntu-ports focal-updates/main arm64 c-n-f Metadata [16.6 kB]
    Get:9 http://ports.ubuntu.com/ubuntu-ports focal-updates/universe arm64 Packages [1015 kB]
    Get:10 http://ports.ubuntu.com/ubuntu-ports focal-updates/universe arm64 c-n-f Metadata [23.6 kB]
    Fetched 3444 kB in 4s (845 kB/s)             
    Reading package lists... 0%Reading package lists... 0%Reading package lists... 0%Reading package lists... 3%Reading package lists... 3%Reading package lists... 5%Reading package lists... 5%Reading package lists... 5%Reading package lists... 5%Reading package lists... 5%Reading package lists... 5%Reading package lists... 37%Reading package lists... 37%Reading package lists... 55%Reading package lists... 55%Reading package lists... 55%Reading package lists... 55%Reading package lists... 55%Reading package lists... 55%Reading package lists... 62%Reading package lists... 62%Reading package lists... 69%Reading package lists... 69%Reading package lists... 69%Reading package lists... 69%Reading package lists... 73%Reading package lists... 73%Reading package lists... 77%Reading package lists... 77%Reading package lists... 78%Reading package lists... 78%Reading package lists... 78%Reading package lists... 78%Reading package lists... 78%Reading package lists... 78%Reading package lists... 78%Reading package lists... 78%Reading package lists... 79%Reading package lists... 79%Reading package lists... 79%Reading package lists... 79%Reading package lists... 79%Reading package lists... 79%Reading package lists... 85%Reading package lists... 85%Reading package lists... 91%Reading package lists... 91%Reading package lists... 91%Reading package lists... 91%Reading package lists... 95%Reading package lists... 95%Reading package lists... 98%Reading package lists... 98%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... Done
    Requirement already satisfied: ansible==6.7.0 in /home/student/.venv/TRAINING/lib/python3.8/site-packages (6.7.0)
    Requirement already satisfied: ansible-core~=2.13.7 in /home/student/.venv/TRAINING/lib/python3.8/site-packages (from ansible==6.7.0) (2.13.11)
    Requirement already satisfied: jinja2>=3.0.0 in /home/student/.venv/TRAINING/lib/python3.8/site-packages (from ansible-core~=2.13.7->ansible==6.7.0) (3.1.2)
    Requirement already satisfied: PyYAML>=5.1 in /home/student/.venv/TRAINING/lib/python3.8/site-packages (from ansible-core~=2.13.7->ansible==6.7.0) (6.0.1)
    Requirement already satisfied: cryptography in /home/student/.venv/TRAINING/lib/python3.8/site-packages (from ansible-core~=2.13.7->ansible==6.7.0) (41.0.3)
    Requirement already satisfied: packaging in /home/student/.venv/TRAINING/lib/python3.8/site-packages (from ansible-core~=2.13.7->ansible==6.7.0) (23.1)
    Requirement already satisfied: resolvelib<0.9.0,>=0.5.3 in /home/student/.venv/TRAINING/lib/python3.8/site-packages (from ansible-core~=2.13.7->ansible==6.7.0) (0.8.1)
    Requirement already satisfied: MarkupSafe>=2.0 in /home/student/.venv/TRAINING/lib/python3.8/site-packages (from jinja2>=3.0.0->ansible-core~=2.13.7->ansible==6.7.0) (2.1.3)
    Requirement already satisfied: cffi>=1.12 in /home/student/.venv/TRAINING/lib/python3.8/site-packages (from cryptography->ansible-core~=2.13.7->ansible==6.7.0) (1.15.1)
    Requirement already satisfied: pycparser in /home/student/.venv/TRAINING/lib/python3.8/site-packages (from cffi>=1.12->cryptography->ansible-core~=2.13.7->ansible==6.7.0) (2.21)



```bash
ansible -m ping -i ~/ansible_inventory all
# Code-Cell[78] In[52]

```

    vm-linux-docker | SUCCESS => {
        "ansible_facts": {
            "discovered_interpreter_python": "/usr/bin/python3"
        },
        "changed": false,
        "ping": "pong"
    }




![](/images/ThinPurpleBar.png)


# Installing Docker on the new VM
<!-- # 2.5 Obtaining the ansible playbooks -->


```bash
mkdir -p ~/src/

[ ! -d ~/src/tf-scenarios ] &&
  git clone https://github.com/mjbright/tf-scenarios ~/src/tf-scenarios


# Code-Cell[80] In[41]

```

<!-- # 2.6 Installing Docker using Ansible -->


![](/images/ThinPurpleBar.png)


# 2.6 Installing Docker

(*due to problems encountered with different ansible versions*)

We will now install Docker using the provided script:

```DOCKER_install_on_ubuntu.sh```

We will first transfer the script to our new virtual machine and execute it there.




```bash
#~/src/tf-scenarios/ansible_playbooks/INSTALL-docker.sh

ls -altr ~/src/tf-scenarios/scripts/
# Code-Cell[83] In[43]

```

    total 20
    -rwxrwxr-x  1 student student 5873 Aug  7 20:42 get_aws_instances.sh
    -rwxrwxr-x  1 student student  846 Aug  7 20:42 DOCKER_install_on_ubuntu.sh
    drwxrwxr-x 13 student student 4096 Aug  7 20:42 ..
    drwxrwxr-x  2 student student 4096 Aug  7 20:42 .



```bash
scp ~/src/tf-scenarios/scripts/DOCKER_install_on_ubuntu.sh vm-linux-docker:
# Code-Cell[84] In[49]

```

    DOCKER_install_on_ubuntu.sh                   100%  836     7.1KB/s   00:00    



```bash
ssh -t vm-linux-docker bash ./DOCKER_install_on_ubuntu.sh
# Code-Cell[85] In[50]

```

    Hit:1 http://azure.archive.ubuntu.com/ubuntu focal InRelease
    Hit:2 http://azure.archive.ubuntu.com/ubuntu focal-updates InRelease
    Hit:3 http://azure.archive.ubuntu.com/ubuntu focal-backports InRelease
    Hit:4 http://azure.archive.ubuntu.com/ubuntu focal-security InRelease
                 Reading package lists... 0%Reading package lists... 0%Reading package lists... 0%Reading package lists... 3%Reading package lists... 3%Reading package lists... 4%Reading package lists... 4%Reading package lists... 4%Reading package lists... 4%Reading package lists... 4%Reading package lists... 4%Reading package lists... 31%Reading package lists... 31%Reading package lists... 45%Reading package lists... 45%Reading package lists... 46%Reading package lists... 46%Reading package lists... 46%Reading package lists... 46%Reading package lists... 50%Reading package lists... 54%Reading package lists... 54%Reading package lists... 59%Reading package lists... 59%Reading package lists... 66%Reading package lists... 66%Reading package lists... 69%Reading package lists... 69%Reading package lists... 73%Reading package lists... 73%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 81%Reading package lists... 81%Reading package lists... 86%Reading package lists... 86%Reading package lists... 93%Reading package lists... 93%Reading package lists... 96%Reading package lists... 96%Reading package lists... 98%Reading package lists... 98%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... Done
    Reading package lists... 0%Reading package lists... 100%Reading package lists... Done
    Building dependency tree... 0%Building dependency tree... 0%Building dependency tree... 50%Building dependency tree... 50%Building dependency tree       
    Reading state information... 0%Reading state information... 0%Reading state information... Done
    lsb-release is already the newest version (11.1.0ubuntu2).
    lsb-release set to manually installed.
    ca-certificates is already the newest version (20230311ubuntu0.20.04.1).
    ca-certificates set to manually installed.
    gnupg is already the newest version (2.2.19-3ubuntu2.2).
    gnupg set to manually installed.
    The following package was automatically installed and is no longer required:
      libfreetype6
    Use 'sudo apt autoremove' to remove it.
    The following additional packages will be installed:
      libcurl4
    The following packages will be upgraded:
      curl libcurl4
    2 upgraded, 0 newly installed, 0 to remove and 40 not upgraded.
    Need to get 396 kB of archives.
    After this operation, 0 B of additional disk space will be used.
    Get:1 http://azure.archive.ubuntu.com/ubuntu focal-updates/main amd64 curl amd64 7.68.0-1ubuntu2.19 [161 kB]
    Get:2 http://azure.archive.ubuntu.com/ubuntu focal-updates/main amd64 libcurl4 amd64 7.68.0-1ubuntu2.19 [235 kB]
    Fetched 396 kB in 0s (9622 kB/s)  
    (Reading database ... 57912 files and directories currently installed.)
    Preparing to unpack .../curl_7.68.0-1ubuntu2.19_amd64.deb ...
    Unpacking curl (7.68.0-1ubuntu2.19) over (7.68.0-1ubuntu2.18) ...
    Preparing to unpack .../libcurl4_7.68.0-1ubuntu2.19_amd64.deb ...
    Unpacking libcurl4:amd64 (7.68.0-1ubuntu2.19) over (7.68.0-1ubuntu2.18) ...
    Setting up libcurl4:amd64 (7.68.0-1ubuntu2.19) ...
    Setting up curl (7.68.0-1ubuntu2.19) ...
    Processing triggers for man-db (2.9.1-1) ...
    Processing triggers for libc-bin (2.31-0ubuntu9.9) ...
    Get:1 https://download.docker.com/linux/ubuntu focal InRelease [57.7 kB]
    Hit:2 http://azure.archive.ubuntu.com/ubuntu focal InRelease                 
    Hit:3 http://azure.archive.ubuntu.com/ubuntu focal-updates InRelease
    Hit:4 http://azure.archive.ubuntu.com/ubuntu focal-backports InRelease
    Hit:5 http://azure.archive.ubuntu.com/ubuntu focal-security InRelease
    Get:6 https://download.docker.com/linux/ubuntu focal/stable amd64 Packages [32.5 kB]
    Fetched 90.2 kB in 1s (104 kB/s)
    Reading package lists... 0%Reading package lists... 0%Reading package lists... 0%Reading package lists... 3%Reading package lists... 3%Reading package lists... 4%Reading package lists... 4%Reading package lists... 4%Reading package lists... 4%Reading package lists... 4%Reading package lists... 4%Reading package lists... 31%Reading package lists... 31%Reading package lists... 45%Reading package lists... 45%Reading package lists... 46%Reading package lists... 46%Reading package lists... 46%Reading package lists... 46%Reading package lists... 49%Reading package lists... 54%Reading package lists... 54%Reading package lists... 59%Reading package lists... 59%Reading package lists... 66%Reading package lists... 66%Reading package lists... 69%Reading package lists... 69%Reading package lists... 72%Reading package lists... 72%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 74%Reading package lists... 81%Reading package lists... 81%Reading package lists... 86%Reading package lists... 86%Reading package lists... 92%Reading package lists... 92%Reading package lists... 95%Reading package lists... 95%Reading package lists... 98%Reading package lists... 98%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... 99%Reading package lists... Done
    Reading package lists... 0%Reading package lists... 100%Reading package lists... Done
    Building dependency tree... 0%Building dependency tree... 0%Building dependency tree... 50%Building dependency tree... 50%Building dependency tree       
    Reading state information... 0%Reading state information... 0%Reading state information... Done
    The following package was automatically installed and is no longer required:
      libfreetype6
    Use 'sudo apt autoremove' to remove it.
    The following additional packages will be installed:
      docker-buildx-plugin docker-ce-rootless-extras pigz slirp4netns
    Suggested packages:
      aufs-tools cgroupfs-mount | cgroup-lite
    The following NEW packages will be installed:
      containerd.io docker-buildx-plugin docker-ce docker-ce-cli
      docker-ce-rootless-extras docker-compose-plugin pigz slirp4netns
    0 upgraded, 8 newly installed, 0 to remove and 40 not upgraded.
    Need to get 114 MB of archives.
    After this operation, 414 MB of additional disk space will be used.
    Get:1 http://azure.archive.ubuntu.com/ubuntu focal/universe amd64 pigz amd64 2.4-1 [57.4 kB]
    Get:2 http://azure.archive.ubuntu.com/ubuntu focal/universe amd64 slirp4netns amd64 0.4.3-1 [74.3 kB]
    Get:3 https://download.docker.com/linux/ubuntu focal/stable amd64 containerd.io amd64 1.6.22-1 [28.3 MB]
    Get:4 https://download.docker.com/linux/ubuntu focal/stable amd64 docker-buildx-plugin amd64 0.11.2-1~ubuntu.20.04~focal [28.2 MB]
    Get:5 https://download.docker.com/linux/ubuntu focal/stable amd64 docker-ce-cli amd64 5:24.0.5-1~ubuntu.20.04~focal [13.3 MB]
    Get:6 https://download.docker.com/linux/ubuntu focal/stable amd64 docker-ce amd64 5:24.0.5-1~ubuntu.20.04~focal [22.9 MB]
    Get:7 https://download.docker.com/linux/ubuntu focal/stable amd64 docker-ce-rootless-extras amd64 5:24.0.5-1~ubuntu.20.04~focal [9032 kB]
    Get:8 https://download.docker.com/linux/ubuntu focal/stable amd64 docker-compose-plugin amd64 2.20.2-1~ubuntu.20.04~focal [11.9 MB]
    Fetched 114 MB in 2s (74.1 MB/s)            
    Selecting previously unselected package pigz.
    (Reading database ... 57912 files and directories currently installed.)
    Preparing to unpack .../0-pigz_2.4-1_amd64.deb ...
    Unpacking pigz (2.4-1) ...
    Selecting previously unselected package containerd.io.
    Preparing to unpack .../1-containerd.io_1.6.22-1_amd64.deb ...
    Unpacking containerd.io (1.6.22-1) ...
    Selecting previously unselected package docker-buildx-plugin.
    Preparing to unpack .../2-docker-buildx-plugin_0.11.2-1~ubuntu.20.04~focal_amd64.deb ...
    Unpacking docker-buildx-plugin (0.11.2-1~ubuntu.20.04~focal) ...
    Selecting previously unselected package docker-ce-cli.
    Preparing to unpack .../3-docker-ce-cli_5%3a24.0.5-1~ubuntu.20.04~focal_amd64.deb ...
    Unpacking docker-ce-cli (5:24.0.5-1~ubuntu.20.04~focal) ...
    Selecting previously unselected package docker-ce.
    Preparing to unpack .../4-docker-ce_5%3a24.0.5-1~ubuntu.20.04~focal_amd64.deb ...
    Unpacking docker-ce (5:24.0.5-1~ubuntu.20.04~focal) ...
    Selecting previously unselected package docker-ce-rootless-extras.
    Preparing to unpack .../5-docker-ce-rootless-extras_5%3a24.0.5-1~ubuntu.20.04~focal_amd64.deb ...
    Unpacking docker-ce-rootless-extras (5:24.0.5-1~ubuntu.20.04~focal) ...
    Selecting previously unselected package docker-compose-plugin.
    Preparing to unpack .../6-docker-compose-plugin_2.20.2-1~ubuntu.20.04~focal_amd64.deb ...
    Unpacking docker-compose-plugin (2.20.2-1~ubuntu.20.04~focal) ...
    Selecting previously unselected package slirp4netns.
    Preparing to unpack .../7-slirp4netns_0.4.3-1_amd64.deb ...
    Unpacking slirp4netns (0.4.3-1) ...
    Setting up slirp4netns (0.4.3-1) ...
    Setting up docker-buildx-plugin (0.11.2-1~ubuntu.20.04~focal) ...
    Setting up containerd.io (1.6.22-1) ...
    Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /lib/systemd/system/containerd.service.
    Setting up docker-compose-plugin (2.20.2-1~ubuntu.20.04~focal) ...
    Setting up docker-ce-cli (5:24.0.5-1~ubuntu.20.04~focal) ...
    Setting up pigz (2.4-1) ...
    Setting up docker-ce-rootless-extras (5:24.0.5-1~ubuntu.20.04~focal) ...
    Setting up docker-ce (5:24.0.5-1~ubuntu.20.04~focal) ...
    Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /lib/systemd/system/docker.service.
    Created symlink /etc/systemd/system/sockets.target.wants/docker.socket → /lib/systemd/system/docker.socket.
    Processing triggers for man-db (2.9.1-1) ...
    Processing triggers for systemd (245.4-4ubuntu3.22) ...
    groupadd: group 'docker' already exists
    Connection to 20.25.90.27 closed.



```bash
ssh vm-linux-docker sudo docker ps
# Code-Cell[86] In[53]

```

    CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES


#### Now check that we can use Docker as the vmadmin (and root) user


```bash
ssh vm-linux-docker docker ps
# Code-Cell[88] In[54]

```

    CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES



```bash
ssh vm-linux-docker docker version
# Code-Cell[89] In[55]

```

    Client: Docker Engine - Community
     Version:           24.0.5
     API version:       1.43
     Go version:        go1.20.6
     Git commit:        ced0996
     Built:             Fri Jul 21 20:35:23 2023
     OS/Arch:           linux/amd64
     Context:           default
    
    Server: Docker Engine - Community
     Engine:
      Version:          24.0.5
      API version:      1.43 (minimum version 1.12)
      Go version:       go1.20.6
      Git commit:       a61e2b4
      Built:            Fri Jul 21 20:35:23 2023
      OS/Arch:          linux/amd64
      Experimental:     false
     containerd:
      Version:          1.6.22
      GitCommit:        8165feabfdfe38c65b599c4993d227328c231fca
     runc:
      Version:          1.1.8
      GitCommit:        v1.1.8-0-g82f18fe
     docker-init:
      Version:          0.19.0
      GitCommit:        de40ad0




![](/images/ThinPurpleBar.png)


# 2.7. Using Terraform with Docker

The purpose of all this was
- to ```demonstrate Azure Virtual Machine creation```
- several ```Terraform concepts```
- provide a ```go faster``` way of creating resources with Terraform

We will see that creation of Docker Containers
- using ```ssh credentials``` in the ```Docker Provider``` spec is much faster than
  - ```virtual machines```
  - or ```cloud containers (aci)```

We will now look at how to configure the ```Docker Provider``` for Terraform to allow us to create (Docker Container) resources.

![](/images/TF-Azure_Labs_png/Azure_Lab2_Concepts_3.png)



![](/images/ThinPurpleBar.png)


## 2.7.1 Creation of a Docker Container [Docker via ssh]


```bash
mkdir -p ~/labs/lab2b
cd       ~/labs/lab2b
# Code-Cell[92] In[57]

```

### 2.7.1.1 Specifying the Provider

Below we create the Provider file specifying that we will use the Docker Provider for this configuration, allowing us to create Docker Container resources with Terraform.

We can see that we can optionally specify the connection parameters.

By default the provider will try to connect to Docker locally on the same machine.

Here we set host and port attributes to connect to Docker in our newly created VirtualMachine via an ssh connection

Create a new file **providers.tf** with the following content:
```txt

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  # We can refer to the host as defined in our ~/.ssh/config file:
  host     = "ssh://vm-linux-docker"
  
  # We can specify full ssh options here
  # - if doing this be sure to use the correct fqdn, not with 'studentn':
  # host     = "ssh://vmadmin@studentn.eastus.cloudapp.azure.com:22"
  # ssh_opts = ["-i", "~/.ssh/id_rsa", "-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}


```


### 2.7.1.2 Create main.tf

Below we see how we can define ```docker_image``` and ```docker_container``` resources.

The container will listen on port 8080

Create a new file **main.tf** with the following content:
```txt

# See https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs
# for options & information about registry access

# Pulls the image
resource "docker_image" "k8s-demo" {
  name = "mjbright/k8s-demo:1"
}

# Create a container
resource "docker_container" "test1" {
  image = docker_image.k8s-demo.image_id
  name  = "test1"

ports {
    internal = 80
    external = 8080
  }
}


```


### 2.7.1.3 Create the resources


```bash
terraform init 
# Code-Cell[98] In[60]

```

    
    Initializing the backend...
    
    Initializing provider plugins...
    - Reusing previous version of kreuzwerker/docker from the dependency lock file
    - Using previously-installed kreuzwerker/docker v3.0.2
    
    Terraform has been successfully initialized!
    
    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.
    
    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.



```bash
terraform plan 
# Code-Cell[99] In[61]

```

    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      + create
    
    Terraform will perform the following actions:
    
      # docker_container.test1 will be created
      + resource "docker_container" "test1" {
          + attach                                      = false
          + bridge                                      = (known after apply)
          + command                                     = (known after apply)
          + container_logs                              = (known after apply)
          + container_read_refresh_timeout_milliseconds = 15000
          + entrypoint                                  = (known after apply)
          + env                                         = (known after apply)
          + exit_code                                   = (known after apply)
          + hostname                                    = (known after apply)
          + id                                          = (known after apply)
          + image                                       = (known after apply)
          + init                                        = (known after apply)
          + ipc_mode                                    = (known after apply)
          + log_driver                                  = (known after apply)
          + logs                                        = false
          + must_run                                    = true
          + name                                        = "test1"
          + network_data                                = (known after apply)
          + read_only                                   = false
          + remove_volumes                              = true
          + restart                                     = "no"
          + rm                                          = false
          + runtime                                     = (known after apply)
          + security_opts                               = (known after apply)
          + shm_size                                    = (known after apply)
          + start                                       = true
          + stdin_open                                  = false
          + stop_signal                                 = (known after apply)
          + stop_timeout                                = (known after apply)
          + tty                                         = false
          + wait                                        = false
          + wait_timeout                                = 60
    
          + ports {
              + external = 8080
              + internal = 80
              + ip       = "0.0.0.0"
              + protocol = "tcp"
            }
        }
    
      # docker_image.k8s-demo will be created
      + resource "docker_image" "k8s-demo" {
          + id          = (known after apply)
          + image_id    = (known after apply)
          + name        = "mjbright/k8s-demo:1"
          + repo_digest = (known after apply)
        }
    
    Plan: 2 to add, 0 to change, 0 to destroy.
    
    ───────────────────────────────────────────────────────────────────────────────
    
    Note: You didn't use the -out option to save this plan, so Terraform can't
    guarantee to take exactly these actions if you run "terraform apply" now.


#### Observe that no containers are running

Prior to the apply there are no running containers on our VirtualMachine


```bash
ssh vm-linux-docker docker ps
# Code-Cell[101] In[62]

```

    CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES



```bash
terraform apply 
# Code-Cell[102] In[63]

```

    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      + create
    
    Terraform will perform the following actions:
    
      # docker_container.test1 will be created
      + resource "docker_container" "test1" {
          + attach                                      = false
          + bridge                                      = (known after apply)
          + command                                     = (known after apply)
          + container_logs                              = (known after apply)
          + container_read_refresh_timeout_milliseconds = 15000
          + entrypoint                                  = (known after apply)
          + env                                         = (known after apply)
          + exit_code                                   = (known after apply)
          + hostname                                    = (known after apply)
          + id                                          = (known after apply)
          + image                                       = (known after apply)
          + init                                        = (known after apply)
          + ipc_mode                                    = (known after apply)
          + log_driver                                  = (known after apply)
          + logs                                        = false
          + must_run                                    = true
          + name                                        = "test1"
          + network_data                                = (known after apply)
          + read_only                                   = false
          + remove_volumes                              = true
          + restart                                     = "no"
          + rm                                          = false
          + runtime                                     = (known after apply)
          + security_opts                               = (known after apply)
          + shm_size                                    = (known after apply)
          + start                                       = true
          + stdin_open                                  = false
          + stop_signal                                 = (known after apply)
          + stop_timeout                                = (known after apply)
          + tty                                         = false
          + wait                                        = false
          + wait_timeout                                = 60
    
          + ports {
              + external = 8080
              + internal = 80
              + ip       = "0.0.0.0"
              + protocol = "tcp"
            }
        }
    
      # docker_image.k8s-demo will be created
      + resource "docker_image" "k8s-demo" {
          + id          = (known after apply)
          + image_id    = (known after apply)
          + name        = "mjbright/k8s-demo:1"
          + repo_digest = (known after apply)
        }
    
    Plan: 2 to add, 0 to change, 0 to destroy.
    docker_image.k8s-demo: Creating...
    docker_image.k8s-demo: Creation complete after 6s [id=sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8mjbright/k8s-demo:1]
    docker_container.test1: Creating...
    docker_container.test1: Creation complete after 3s [id=15bdc28018280e9ff59c56041f9c9603b919ce4103bfaa645d4d0d2b1c14fb69]
    
    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.


#### Observe that the container is running

Post apply, we can verify that the container was created.


```bash
ssh vm-linux-docker docker ps
# Code-Cell[104] In[64]

```

    CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                  NAMES
    15bdc2801828   3374313a7430   "/app/demo-binary -l…"   7 seconds ago   Up 5 seconds   0.0.0.0:8080->80/tcp   test1


### 2.7.1.4 Connect to the Container

As port 8080 is open on the VirtualMachine (by default) we can curl directly to the newly created container on it's public address


```bash
curl -L student20.eastus.cloudapp.azure.com:8080
# Code-Cell[107] In[66]

```

    
                        (((((((((                  
                   .(((((((((((((((((.             
               .((((((((((((&((((((((((((.         
           /((((((((((((((((@((((((((((((((((/     
          ((((((((((((((((((@((((((((((((((((((    
         *(((((##((((((@@@@@@@@@@@((((((%#(((((*   
         (((((((@@@(@@@@#((@@@((#@@@@(@@@(((((((   
        *(((((((((@@@@(((((@@@(((((@@@@(((((((((,  
        (((((((((@@@%@@@@((@@@((@@@@%@@@(((((((((  
       .(((((((((@@((((@@@@@@@@@@@((((@@(((((((((. 
       (((((((((&@@(((((@@@(((@@@(((((@@&((((((((( 
       (((((((((&@@@@@@@@@@#(#@@@@@@@@@@&((((((((( 
      ((((((@@@@@@@@(((((@@@@@@@(((((&@@@@@@@((((((
      (((((((((((%@@((((%@@@(@@@%((((@@&(((((((((((
       ((((((((((((@@@((@@%(((%@@((@@@(((((((((((( 
         (((((((((((#@@@@%(((((&@@@@#(((((((((((   
          /(((((((((((@@@@@@@@@@@@@(((((((((((/    
            (((((((((@@(((((((((((@@(((((((((      
              (((((((&(((((((((((((&(((((((        
               /(((((((((((((((((((((((((/         
                 (((((((((((((((((((((((           
    
    pod 15bdc2801828@172.17.0.2 image[mjbright/k8s-demo:1] Request from 78.144.117.75:63023




![](/images/ThinPurpleBar.png)


## 2.7.1.6 Re-apply the configuration

Now let's re-run the apply to see what happens.

You should see something like:


```bash
terraform apply 
# Code-Cell[109] In[67]

```

    docker_image.k8s-demo: Refreshing state... [id=sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8mjbright/k8s-demo:1]
    docker_container.test1: Refreshing state... [id=15bdc28018280e9ff59c56041f9c9603b919ce4103bfaa645d4d0d2b1c14fb69]
    
    No changes. Your infrastructure matches the configuration.
    
    Terraform has compared your real infrastructure against your configuration and
    found no differences, so no changes are needed.
    
    Apply complete! Resources: 0 added, 0 changed, 0 destroyed.


Note that this time nothing changes - why is that?



![](/images/ThinPurpleBar.png)


## 2.7.1.7 Inspect the terraform.tfstate file


```bash
cat terraform.tfstate

# Code-Cell[111] In[68]

```

    {
      "version": 4,
      "terraform_version": "1.5.5",
      "serial": 17,
      "lineage": "1e257751-30b6-27bf-b720-4778ca62f249",
      "outputs": {},
      "resources": [
        {
          "mode": "managed",
          "type": "docker_container",
          "name": "test1",
          "provider": "provider[\"registry.terraform.io/kreuzwerker/docker\"]",
          "instances": [
            {
              "schema_version": 2,
    ....


What information does it contain?

What format is this file in?

Well since it's in that format we can parse it using jq, e.g. to get the private ip address of the VM.

#### Investigating the terraform.tfstate file

We can use different external tools to examine the file which is in json format.
- python3 using the json module
- jq tool

First look at the resources/instances with jq.


```bash
jq -M '.resources[].instances[]' terraform.tfstate
# Code-Cell[113] In[69]

```

    {
      "schema_version": 2,
      "attributes": {
        "attach": false,
        "bridge": "",
        "capabilities": [],
        "cgroupns_mode": null,
        "command": [
          "/app/demo-binary",
          "-l",
          "80",
          "-L",
          "0",
          "-R",
          "0"
        ],
        "container_logs": null,
        "container_read_refresh_timeout_milliseconds": 15000,
        "cpu_set": "",
        "cpu_shares": 0,
        "destroy_grace_seconds": null,
        "devices": [],
        "dns": [],
        "dns_opts": [],
        "dns_search": [],
        "domainname": "",
        "entrypoint": [],
        "env": [],
        "exit_code": null,
        "gpus": null,
        "group_add": [],
        "healthcheck": [],
        "host": [],
        "hostname": "15bdc2801828",
        "id": "15bdc28018280e9ff59c56041f9c9603b919ce4103bfaa645d4d0d2b1c14fb69",
        "image": "sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8",
        "init": false,
        "ipc_mode": "private",
        "labels": [],
        "log_driver": "json-file",
        "log_opts": {},
        "logs": false,
        "max_retry_count": 0,
        "memory": 0,
        "memory_swap": 0,
        "mounts": [],
        "must_run": true,
        "name": "test1",
        "network_data": [
          {
            "gateway": "172.17.0.1",
            "global_ipv6_address": "",
            "global_ipv6_prefix_length": 0,
            "ip_address": "172.17.0.2",
            "ip_prefix_length": 16,
            "ipv6_gateway": "",
            "mac_address": "02:42:ac:11:00:02",
            "network_name": "bridge"
          }
        ],
        "network_mode": "default",
        "networks_advanced": [],
        "pid_mode": "",
        "ports": [
          {
            "external": 8080,
            "internal": 80,
            "ip": "0.0.0.0",
            "protocol": "tcp"
          }
        ],
        "privileged": false,
        "publish_all_ports": false,
        "read_only": false,
        "remove_volumes": true,
        "restart": "no",
        "rm": false,
        "runtime": "runc",
        "security_opts": [],
        "shm_size": 64,
        "start": true,
        "stdin_open": false,
        "stop_signal": "",
        "stop_timeout": 0,
        "storage_opts": {},
        "sysctls": {},
        "tmpfs": {},
        "tty": false,
        "ulimit": [],
        "upload": [],
        "user": "",
        "userns_mode": "",
        "volumes": [],
        "wait": false,
        "wait_timeout": 60,
        "working_dir": "/app"
      },
      "sensitive_attributes": [],
      "private": "eyJzY2hlbWFfdmVyc2lvbiI6IjIifQ==",
      "dependencies": [
        "docker_image.k8s-demo"
      ]
    }
    {
      "schema_version": 0,
      "attributes": {
        "build": [],
        "force_remove": null,
        "id": "sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8mjbright/k8s-demo:1",
        "image_id": "sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8",
        "keep_locally": null,
        "name": "mjbright/k8s-demo:1",
        "platform": null,
        "pull_triggers": null,
        "repo_digest": "mjbright/k8s-demo@sha256:f69fd318cdb1f236fe3c2331acce41e6b247d86a17484ecb5935159d65662d77",
        "triggers": null
      },
      "sensitive_attributes": [],
      "private": "bnVsbA=="
    }


The above matches also on all resources not just of VirtualMachines.

Can you figure out how to select just the private and public ip addresses ?

Hint: We're not here to jq so feel free to try jq combined with grep !!



```bash
jq -M '.resources[].instances[].attributes' terraform.tfstate
# Code-Cell[115] In[70]

```

    {
      "attach": false,
      "bridge": "",
      "capabilities": [],
      "cgroupns_mode": null,
      "command": [
        "/app/demo-binary",
        "-l",
        "80",
        "-L",
        "0",
        "-R",
        "0"
      ],
      "container_logs": null,
      "container_read_refresh_timeout_milliseconds": 15000,
      "cpu_set": "",
      "cpu_shares": 0,
      "destroy_grace_seconds": null,
      "devices": [],
      "dns": [],
      "dns_opts": [],
      "dns_search": [],
      "domainname": "",
      "entrypoint": [],
      "env": [],
      "exit_code": null,
      "gpus": null,
      "group_add": [],
      "healthcheck": [],
      "host": [],
      "hostname": "15bdc2801828",
      "id": "15bdc28018280e9ff59c56041f9c9603b919ce4103bfaa645d4d0d2b1c14fb69",
      "image": "sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8",
      "init": false,
      "ipc_mode": "private",
      "labels": [],
      "log_driver": "json-file",
      "log_opts": {},
      "logs": false,
      "max_retry_count": 0,
      "memory": 0,
      "memory_swap": 0,
      "mounts": [],
      "must_run": true,
      "name": "test1",
      "network_data": [
        {
          "gateway": "172.17.0.1",
          "global_ipv6_address": "",
          "global_ipv6_prefix_length": 0,
          "ip_address": "172.17.0.2",
          "ip_prefix_length": 16,
          "ipv6_gateway": "",
          "mac_address": "02:42:ac:11:00:02",
          "network_name": "bridge"
        }
      ],
      "network_mode": "default",
      "networks_advanced": [],
      "pid_mode": "",
      "ports": [
        {
          "external": 8080,
          "internal": 80,
          "ip": "0.0.0.0",
          "protocol": "tcp"
        }
      ],
      "privileged": false,
      "publish_all_ports": false,
      "read_only": false,
      "remove_volumes": true,
      "restart": "no",
      "rm": false,
      "runtime": "runc",
      "security_opts": [],
      "shm_size": 64,
      "start": true,
      "stdin_open": false,
      "stop_signal": "",
      "stop_timeout": 0,
      "storage_opts": {},
      "sysctls": {},
      "tmpfs": {},
      "tty": false,
      "ulimit": [],
      "upload": [],
      "user": "",
      "userns_mode": "",
      "volumes": [],
      "wait": false,
      "wait_timeout": 60,
      "working_dir": "/app"
    }
    {
      "build": [],
      "force_remove": null,
      "id": "sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8mjbright/k8s-demo:1",
      "image_id": "sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8",
      "keep_locally": null,
      "name": "mjbright/k8s-demo:1",
      "platform": null,
      "pull_triggers": null,
      "repo_digest": "mjbright/k8s-demo@sha256:f69fd318cdb1f236fe3c2331acce41e6b247d86a17484ecb5935159d65662d77",
      "triggers": null
    }


Of course there are other *terraform* ways to obtain this information


```bash
terraform output
# Code-Cell[117] In[71]

```

    ╷
    │ Warning: No outputs found
    │ 
    │ The state file either has no outputs defined, or all the defined outputs are
    │ empty. Please define an output in your configuration with the `output`
    │ keyword and run `terraform refresh` for it to become available. If you are
    │ using interpolation, please verify the interpolated value is not empty. You
    │ can use the `terraform console` command to assist.
    ╵



```bash
jq '.outputs' terraform.tfstate
# Code-Cell[118] In[72]

```

    [1;39m{}



```bash
terraform show
# Code-Cell[119] In[73]

```

    # docker_container.test1:
    resource "docker_container" "test1" {
        attach                                      = false
        command                                     = [
            "/app/demo-binary",
            "-l",
            "80",
            "-L",
            "0",
            "-R",
            "0",
        ]
        container_read_refresh_timeout_milliseconds = 15000
        cpu_shares                                  = 0
        dns                                         = []
        dns_opts                                    = []
        dns_search                                  = []
        entrypoint                                  = []
        env                                         = []
        group_add                                   = []
        hostname                                    = "15bdc2801828"
        id                                          = "15bdc28018280e9ff59c56041f9c9603b919ce4103bfaa645d4d0d2b1c14fb69"
        image                                       = "sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8"
        init                                        = false
        ipc_mode                                    = "private"
        log_driver                                  = "json-file"
        log_opts                                    = {}
        logs                                        = false
        max_retry_count                             = 0
        memory                                      = 0
        memory_swap                                 = 0
        must_run                                    = true
        name                                        = "test1"
        network_data                                = [
            {
                gateway                   = "172.17.0.1"
                global_ipv6_address       = ""
                global_ipv6_prefix_length = 0
                ip_address                = "172.17.0.2"
                ip_prefix_length          = 16
                ipv6_gateway              = ""
                mac_address               = "02:42:ac:11:00:02"
                network_name              = "bridge"
            },
        ]
        network_mode                                = "default"
        privileged                                  = false
        publish_all_ports                           = false
        read_only                                   = false
        remove_volumes                              = true
        restart                                     = "no"
        rm                                          = false
        runtime                                     = "runc"
        security_opts                               = []
        shm_size                                    = 64
        start                                       = true
        stdin_open                                  = false
        stop_timeout                                = 0
        storage_opts                                = {}
        sysctls                                     = {}
        tmpfs                                       = {}
        tty                                         = false
        wait                                        = false
        wait_timeout                                = 60
        working_dir                                 = "/app"
    
        ports {
            external = 8080
            internal = 80
            ip       = "0.0.0.0"
            protocol = "tcp"
        }
    }
    
    # docker_image.k8s-demo:
    resource "docker_image" "k8s-demo" {
        id          = "sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8mjbright/k8s-demo:1"
        image_id    = "sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8"
        name        = "mjbright/k8s-demo:1"
        repo_digest = "mjbright/k8s-demo@sha256:f69fd318cdb1f236fe3c2331acce41e6b247d86a17484ecb5935159d65662d77"
    }



```bash
terraform state list
# Code-Cell[120] In[74]

```

    docker_container.test1
    docker_image.k8s-demo



```bash
terraform state show docker_container.test1
# Code-Cell[121] In[76]

```

    # docker_container.test1:
    resource "docker_container" "test1" {
        attach                                      = false
        command                                     = [
            "/app/demo-binary",
            "-l",
            "80",
            "-L",
            "0",
            "-R",
            "0",
        ]
        container_read_refresh_timeout_milliseconds = 15000
        cpu_shares                                  = 0
        dns                                         = []
        dns_opts                                    = []
        dns_search                                  = []
        entrypoint                                  = []
        env                                         = []
        group_add                                   = []
        hostname                                    = "15bdc2801828"
        id                                          = "15bdc28018280e9ff59c56041f9c9603b919ce4103bfaa645d4d0d2b1c14fb69"
        image                                       = "sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8"
        init                                        = false
        ipc_mode                                    = "private"
        log_driver                                  = "json-file"
        log_opts                                    = {}
        logs                                        = false
        max_retry_count                             = 0
        memory                                      = 0
        memory_swap                                 = 0
        must_run                                    = true
        name                                        = "test1"
        network_data                                = [
            {
                gateway                   = "172.17.0.1"
                global_ipv6_address       = ""
                global_ipv6_prefix_length = 0
                ip_address                = "172.17.0.2"
                ip_prefix_length          = 16
                ipv6_gateway              = ""
                mac_address               = "02:42:ac:11:00:02"
                network_name              = "bridge"
            },
        ]
        network_mode                                = "default"
        privileged                                  = false
        publish_all_ports                           = false
        read_only                                   = false
        remove_volumes                              = true
        restart                                     = "no"
        rm                                          = false
        runtime                                     = "runc"
        security_opts                               = []
        shm_size                                    = 64
        start                                       = true
        stdin_open                                  = false
        stop_timeout                                = 0
        storage_opts                                = {}
        sysctls                                     = {}
        tmpfs                                       = {}
        tty                                         = false
        wait                                        = false
        wait_timeout                                = 60
        working_dir                                 = "/app"
    
        ports {
            external = 8080
            internal = 80
            ip       = "0.0.0.0"
            protocol = "tcp"
        }
    }



```bash
grep ip terraform.tfstate
# Code-Cell[122] In[77]

```

                "ipc_mode": "private",
                    "global_ipv6_address": "",
                    "global_ipv6_prefix_length": 0,
                    "ip_address": "172.17.0.2",
                    "ip_prefix_length": 16,
                    "ipv6_gateway": "",
                    "ip": "0.0.0.0",



```bash
terraform show | grep "ip"
# Code-Cell[123] In[78]

```

        ipc_mode                                    = "private"
                global_ipv6_address       = ""
                global_ipv6_prefix_length = 0
                ip_address                = "172.17.0.2"
                ip_prefix_length          = 16
                ipv6_gateway              = ""
            ip       = "0.0.0.0"


would have got us the information in a more direct but less programmatic manner


### 2.7.1.8 Cleanup

Before moving on we will cleanup the ```container``` by performing terraform destroy ```FROM THE ~/labs/lab2b``` directory.

(but not the VM which we will continue to use !
 **Do not** run **terraform destroy** from the ~/labs/lab2 directory)


```bash
cd ~/labs/lab2b

terraform destroy 
# Code-Cell[126] In[79]

```

    docker_image.k8s-demo: Refreshing state... [id=sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8mjbright/k8s-demo:1]
    docker_container.test1: Refreshing state... [id=15bdc28018280e9ff59c56041f9c9603b919ce4103bfaa645d4d0d2b1c14fb69]
    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      - destroy
    
    Terraform will perform the following actions:
    
      # docker_container.test1 will be destroyed
      - resource "docker_container" "test1" {
          - attach                                      = false -> null
          - command                                     = [
              - "/app/demo-binary",
              - "-l",
              - "80",
              - "-L",
              - "0",
              - "-R",
              - "0",
            ] -> null
          - container_read_refresh_timeout_milliseconds = 15000 -> null
          - cpu_shares                                  = 0 -> null
          - dns                                         = [] -> null
          - dns_opts                                    = [] -> null
          - dns_search                                  = [] -> null
          - entrypoint                                  = [] -> null
          - env                                         = [] -> null
          - group_add                                   = [] -> null
          - hostname                                    = "15bdc2801828" -> null
          - id                                          = "15bdc28018280e9ff59c56041f9c9603b919ce4103bfaa645d4d0d2b1c14fb69" -> null
          - image                                       = "sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8" -> null
          - init                                        = false -> null
          - ipc_mode                                    = "private" -> null
          - log_driver                                  = "json-file" -> null
          - log_opts                                    = {} -> null
          - logs                                        = false -> null
          - max_retry_count                             = 0 -> null
          - memory                                      = 0 -> null
          - memory_swap                                 = 0 -> null
          - must_run                                    = true -> null
          - name                                        = "test1" -> null
          - network_data                                = [
              - {
                  - gateway                   = "172.17.0.1"
                  - global_ipv6_address       = ""
                  - global_ipv6_prefix_length = 0
                  - ip_address                = "172.17.0.2"
                  - ip_prefix_length          = 16
                  - ipv6_gateway              = ""
                  - mac_address               = "02:42:ac:11:00:02"
                  - network_name              = "bridge"
                },
            ] -> null
          - network_mode                                = "default" -> null
          - privileged                                  = false -> null
          - publish_all_ports                           = false -> null
          - read_only                                   = false -> null
          - remove_volumes                              = true -> null
          - restart                                     = "no" -> null
          - rm                                          = false -> null
          - runtime                                     = "runc" -> null
          - security_opts                               = [] -> null
          - shm_size                                    = 64 -> null
          - start                                       = true -> null
          - stdin_open                                  = false -> null
          - stop_timeout                                = 0 -> null
          - storage_opts                                = {} -> null
          - sysctls                                     = {} -> null
          - tmpfs                                       = {} -> null
          - tty                                         = false -> null
          - wait                                        = false -> null
          - wait_timeout                                = 60 -> null
          - working_dir                                 = "/app" -> null
    
          - ports {
              - external = 8080 -> null
              - internal = 80 -> null
              - ip       = "0.0.0.0" -> null
              - protocol = "tcp" -> null
            }
        }
    
      # docker_image.k8s-demo will be destroyed
      - resource "docker_image" "k8s-demo" {
          - id          = "sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8mjbright/k8s-demo:1" -> null
          - image_id    = "sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8" -> null
          - name        = "mjbright/k8s-demo:1" -> null
          - repo_digest = "mjbright/k8s-demo@sha256:f69fd318cdb1f236fe3c2331acce41e6b247d86a17484ecb5935159d65662d77" -> null
        }
    
    Plan: 0 to add, 0 to change, 2 to destroy.
    docker_container.test1: Destroying... [id=15bdc28018280e9ff59c56041f9c9603b919ce4103bfaa645d4d0d2b1c14fb69]
    docker_container.test1: Destruction complete after 4s
    docker_image.k8s-demo: Destroying... [id=sha256:3374313a743006d37984b6818d4c18df15ab4e6432ea1ae189791d2c36fb3dd8mjbright/k8s-demo:1]
    docker_image.k8s-demo: Destruction complete after 2s
    
    Destroy complete! Resources: 2 destroyed.



```bash
ssh vm-linux-docker docker ps
# Code-Cell[127] In[80]

```

    CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES




![](/images/ThinPurpleBar.png)


## 2.7.2 OPTIONAL: Docker Container Creation [local Docker]

We will continue to work with Docker as we continue to explore Terraform concepts.

<p style="border-width:3px; border-style:solid; border-color:#00AA00; background-color: #eeffee; border-radius: 15px; padding: 1em;"><b>Info: </b> If you have a local Docker on your machine you may choose to use that for the labs that use Docker, this will be even faster than using the cloud Virtual Machine.
</p>


![](/images/TF-Azure_Labs_png/Azure_Lab2_Concepts_4.png)



```bash
# OPTIONAL (local Docker)

mkdir -p ~/labs/lab2c.localDocker
cd       ~/labs/lab2c.localDocker
# Code-Cell[129] In[81]

```


```bash
# OPTIONAL (local Docker)


terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
}

EOF
# Code-Cell[130] In[82]

```


```bash
# OPTIONAL (local Docker)


# See https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs
# for options & information about registry access

# Pulls the image
resource "docker_image" "k8s-demo" {
  name = "mjbright/k8s-demo:1"
}

# Create a container
resource "docker_container" "test1" {
  image = docker_image.k8s-demo.image_id
  name  = "test1"

ports {
    internal = 80
    external = 9090
  }
}

EOF
# Code-Cell[131] In[83]

```

#### Observe that no containers are running

Prior to the apply there are no running containers on our local machine


```bash
# OPTIONAL (local Docker)

docker ps
# Code-Cell[134] In[84]

```

    CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES



```bash
# OPTIONAL (local Docker)

terraform init 
# Code-Cell[135] In[85]

```

    
    Initializing the backend...
    
    Initializing provider plugins...
    - Reusing previous version of kreuzwerker/docker from the dependency lock file
    - Using previously-installed kreuzwerker/docker v3.0.2
    
    Terraform has been successfully initialized!
    
    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.
    
    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.



```bash
# OPTIONAL (local Docker)

terraform plan 
# Code-Cell[136] In[86]

```

    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      + create
    
    Terraform will perform the following actions:
    
      # docker_container.test1 will be created
      + resource "docker_container" "test1" {
          + attach                                      = false
          + bridge                                      = (known after apply)
          + command                                     = (known after apply)
          + container_logs                              = (known after apply)
          + container_read_refresh_timeout_milliseconds = 15000
          + entrypoint                                  = (known after apply)
          + env                                         = (known after apply)
          + exit_code                                   = (known after apply)
          + hostname                                    = (known after apply)
          + id                                          = (known after apply)
          + image                                       = (known after apply)
          + init                                        = (known after apply)
          + ipc_mode                                    = (known after apply)
          + log_driver                                  = (known after apply)
          + logs                                        = false
          + must_run                                    = true
          + name                                        = "test1"
          + network_data                                = (known after apply)
          + read_only                                   = false
          + remove_volumes                              = true
          + restart                                     = "no"
          + rm                                          = false
          + runtime                                     = (known after apply)
          + security_opts                               = (known after apply)
          + shm_size                                    = (known after apply)
          + start                                       = true
          + stdin_open                                  = false
          + stop_signal                                 = (known after apply)
          + stop_timeout                                = (known after apply)
          + tty                                         = false
          + wait                                        = false
          + wait_timeout                                = 60
    
          + ports {
              + external = 9090
              + internal = 80
              + ip       = "0.0.0.0"
              + protocol = "tcp"
            }
        }
    
      # docker_image.k8s-demo will be created
      + resource "docker_image" "k8s-demo" {
          + id          = (known after apply)
          + image_id    = (known after apply)
          + name        = "mjbright/k8s-demo:1"
          + repo_digest = (known after apply)
        }
    
    Plan: 2 to add, 0 to change, 0 to destroy.
    
    ───────────────────────────────────────────────────────────────────────────────
    
    Note: You didn't use the -out option to save this plan, so Terraform can't
    guarantee to take exactly these actions if you run "terraform apply" now.



```bash
# OPTIONAL (local Docker)

terraform apply 
# Code-Cell[137] In[88]

```

    docker_image.k8s-demo: Refreshing state... [id=sha256:6e429abcef8bc422f335dbba19092d7c390ceb1455a218ad171fe7e5eb337488mjbright/k8s-demo:1]
    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      + create
    
    Terraform will perform the following actions:
    
      # docker_container.test1 will be created
      + resource "docker_container" "test1" {
          + attach                                      = false
          + bridge                                      = (known after apply)
          + command                                     = (known after apply)
          + container_logs                              = (known after apply)
          + container_read_refresh_timeout_milliseconds = 15000
          + entrypoint                                  = (known after apply)
          + env                                         = (known after apply)
          + exit_code                                   = (known after apply)
          + hostname                                    = (known after apply)
          + id                                          = (known after apply)
          + image                                       = "sha256:6e429abcef8bc422f335dbba19092d7c390ceb1455a218ad171fe7e5eb337488"
          + init                                        = (known after apply)
          + ipc_mode                                    = (known after apply)
          + log_driver                                  = (known after apply)
          + logs                                        = false
          + must_run                                    = true
          + name                                        = "test1"
          + network_data                                = (known after apply)
          + read_only                                   = false
          + remove_volumes                              = true
          + restart                                     = "no"
          + rm                                          = false
          + runtime                                     = (known after apply)
          + security_opts                               = (known after apply)
          + shm_size                                    = (known after apply)
          + start                                       = true
          + stdin_open                                  = false
          + stop_signal                                 = (known after apply)
          + stop_timeout                                = (known after apply)
          + tty                                         = false
          + wait                                        = false
          + wait_timeout                                = 60
    
          + ports {
              + external = 9090
              + internal = 80
              + ip       = "0.0.0.0"
              + protocol = "tcp"
            }
        }
    
    Plan: 1 to add, 0 to change, 0 to destroy.
    docker_container.test1: Creating...
    docker_container.test1: Creation complete after 1s [id=e10965489ea4621509272c6721fa1810aa66fef9d9cde5db786dbeac6697c38f]
    
    Apply complete! Resources: 1 added, 0 changed, 0 destroyed.


#### Observe that the container has been created



```bash
# OPTIONAL (local Docker)

docker ps
# Code-Cell[139] In[89]

```

    CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                  NAMES
    e10965489ea4   6e429abcef8b   "/app/demo-binary -l…"   7 seconds ago   Up 6 seconds   0.0.0.0:9090->80/tcp   test1




![](/images/ThinPurpleBar.png)


# Cleanup


```bash
terraform destroy 
# Code-Cell[141] In[90]

```

    docker_image.k8s-demo: Refreshing state... [id=sha256:6e429abcef8bc422f335dbba19092d7c390ceb1455a218ad171fe7e5eb337488mjbright/k8s-demo:1]
    docker_container.test1: Refreshing state... [id=e10965489ea4621509272c6721fa1810aa66fef9d9cde5db786dbeac6697c38f]
    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      - destroy
    
    Terraform will perform the following actions:
    
      # docker_container.test1 will be destroyed
      - resource "docker_container" "test1" {
          - attach                                      = false -> null
          - command                                     = [
              - "/app/demo-binary",
              - "-l",
              - "80",
              - "-L",
              - "0",
              - "-R",
              - "0",
            ] -> null
          - container_read_refresh_timeout_milliseconds = 15000 -> null
          - cpu_shares                                  = 0 -> null
          - dns                                         = [] -> null
          - dns_opts                                    = [] -> null
          - dns_search                                  = [] -> null
          - entrypoint                                  = [] -> null
          - env                                         = [] -> null
          - group_add                                   = [] -> null
          - hostname                                    = "e10965489ea4" -> null
          - id                                          = "e10965489ea4621509272c6721fa1810aa66fef9d9cde5db786dbeac6697c38f" -> null
          - image                                       = "sha256:6e429abcef8bc422f335dbba19092d7c390ceb1455a218ad171fe7e5eb337488" -> null
          - init                                        = false -> null
          - ipc_mode                                    = "private" -> null
          - log_driver                                  = "json-file" -> null
          - log_opts                                    = {} -> null
          - logs                                        = false -> null
          - max_retry_count                             = 0 -> null
          - memory                                      = 0 -> null
          - memory_swap                                 = 0 -> null
          - must_run                                    = true -> null
          - name                                        = "test1" -> null
          - network_data                                = [
              - {
                  - gateway                   = "172.17.0.1"
                  - global_ipv6_address       = ""
                  - global_ipv6_prefix_length = 0
                  - ip_address                = "172.17.0.2"
                  - ip_prefix_length          = 16
                  - ipv6_gateway              = ""
                  - mac_address               = "02:42:ac:11:00:02"
                  - network_name              = "bridge"
                },
            ] -> null
          - network_mode                                = "default" -> null
          - privileged                                  = false -> null
          - publish_all_ports                           = false -> null
          - read_only                                   = false -> null
          - remove_volumes                              = true -> null
          - restart                                     = "no" -> null
          - rm                                          = false -> null
          - runtime                                     = "runc" -> null
          - security_opts                               = [] -> null
          - shm_size                                    = 64 -> null
          - start                                       = true -> null
          - stdin_open                                  = false -> null
          - stop_timeout                                = 0 -> null
          - storage_opts                                = {} -> null
          - sysctls                                     = {} -> null
          - tmpfs                                       = {} -> null
          - tty                                         = false -> null
          - wait                                        = false -> null
          - wait_timeout                                = 60 -> null
          - working_dir                                 = "/app" -> null
    
          - ports {
              - external = 9090 -> null
              - internal = 80 -> null
              - ip       = "0.0.0.0" -> null
              - protocol = "tcp" -> null
            }
        }
    
      # docker_image.k8s-demo will be destroyed
      - resource "docker_image" "k8s-demo" {
          - id          = "sha256:6e429abcef8bc422f335dbba19092d7c390ceb1455a218ad171fe7e5eb337488mjbright/k8s-demo:1" -> null
          - image_id    = "sha256:6e429abcef8bc422f335dbba19092d7c390ceb1455a218ad171fe7e5eb337488" -> null
          - name        = "mjbright/k8s-demo:1" -> null
          - repo_digest = "mjbright/k8s-demo@sha256:f69fd318cdb1f236fe3c2331acce41e6b247d86a17484ecb5935159d65662d77" -> null
        }
    
    Plan: 0 to add, 0 to change, 2 to destroy.
    docker_container.test1: Destroying... [id=e10965489ea4621509272c6721fa1810aa66fef9d9cde5db786dbeac6697c38f]
    docker_container.test1: Destruction complete after 0s
    docker_image.k8s-demo: Destroying... [id=sha256:6e429abcef8bc422f335dbba19092d7c390ceb1455a218ad171fe7e5eb337488mjbright/k8s-demo:1]
    docker_image.k8s-demo: Destruction complete after 0s
    
    Destroy complete! Resources: 2 destroyed.


<hr/>



![](/images/ThinPurpleBar.png)


# Summary

In this exercise we
- again went through the workflow of init, plan, apply steps to create an resources.
- created an Azure Virtual Machine
- used outputs to show the public ip address and fqdn on the VM
- connected to it's public ip address via ssh
- added code to generate an ansible inventory file (using string templating)
- installed Docker using a provided script (which calls out to Ansible)
  - **Note:** Terraform is best at creating infrastructure resources such as VMs
    Ansible is best for installing & configuring software on those resources
- created a graphic representing our infrastructure
- used the Terraform Docker Provider to create containers on the remote VM which we created & configured
  - using ssh as the transport to the Docker daemon (specified in the ```provider configuration```)
- OPTIONALLY used the Docker Provider with a local Docker (on your laptop)
- did not destroy this config as we will reuse it for following labs

We saw that
- creating VMs in the cloud can be quite slow
- creating Containers in the cloud can be faster
- OPTIONALLY: creating Containers locally is faster still

<p style="display: inline-block; border-width:3px; border-style:solid; border-color:#0000AA; background-color: #ffffff; border-radius: 15px; padding: 1em;"><b>Note: </b> This has set us up to experiment more with Terraform itself without the delays of managing cloud Virtual Machines.
</p>




![](/images/ThinPurpleBar.png)


# Solutions

Solutions are available in the *github* repo at ```https://github.com/mjbright/tf-scenarios``` under the Solutions folder

