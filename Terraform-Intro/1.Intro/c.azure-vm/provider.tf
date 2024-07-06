
# We declare that we want to use the "azurerm" Provider to create "azurerm_*" resources

provider azurerm {

  # Specific to "azurerm" we must specify a "features" block, even if empty as here:
  features {}

  # You can discover more about "azurerm" features at:
  # https://registry.terraform.io/providers/hashicorp/Azurerm/latest/docs/guides/features-block
}

