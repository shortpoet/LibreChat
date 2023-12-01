terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.80.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
  backend "azurerm" {
    subscription_id      = "060cfbfe-45ab-4a1c-84fc-c056e94221be"
    resource_group_name  = "terraform-backend"
    storage_account_name = "shortpoettfstate"
    container_name       = "tfstate"
    key                  = "shortpoet/LibreChat/infra_app/azure/dev.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
}
