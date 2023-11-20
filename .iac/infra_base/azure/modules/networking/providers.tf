terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0, < 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
}
