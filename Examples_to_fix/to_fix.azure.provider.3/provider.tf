
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.12.0"
    }
  }

  required_version = "~> 1.5.4"
}

# For provider features, refer to:
# - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/features-block

# For provider authentication methods, refer to:
# - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

provider "azurerm" {
  features {}
  # subscription_id = "xxxx-xxxx-xxxx"
}


