data "terraform_remote_state" "infra_base" {
  backend = "azurerm"
  config = {
    subscription_id      = "060cfbfe-45ab-4a1c-84fc-c056e94221be"
    resource_group_name  = "terraform-backend"
    storage_account_name = "shortpoettfstate"
    container_name       = "tfstate"
    key                  = "shortpoet/LibreChat/infra_base/azure/dev.tfstate"
  }
}
