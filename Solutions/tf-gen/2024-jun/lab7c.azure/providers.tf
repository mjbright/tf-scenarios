
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.66.0"
    }
  }

  required_version = ">= 1.7"
}

# For provider features, refer to:
# - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/features-block

# For provider authentication methods, refer to:
# - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

provider "azurerm" {
  features {}
  # subscription_id = "xxxx-xxxx-xxxx"
}
