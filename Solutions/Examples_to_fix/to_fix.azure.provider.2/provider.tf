
terraform {
    required_version = "~> 1.5.1"

    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "> 3.2"
        }
    }
}

# For provider features, refer to:
# - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/features-block

# For provider authentication methods, refer to:
# - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

provider "azurerm" {
    features {}
}


