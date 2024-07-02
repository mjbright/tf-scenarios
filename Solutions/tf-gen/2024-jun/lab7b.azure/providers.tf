
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.66.0"
    }
  }

  required_version = ">= 1.7"
}

provider "azurerm" {
  features {}
}
