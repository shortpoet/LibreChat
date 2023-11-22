resource "azurerm_resource_group" "librechat" {
  name     = local.librechat_resource_group_name
  location = local.location
}

module "networking" {

  source = "../../modules/networking"

  subscription_id      = local.subscription_id
  environment          = local.environment
  resource_group_name  = azurerm_resource_group.librechat.name
  location             = azurerm_resource_group.librechat.location
  application_name     = local.application_name
  default_tags_enabled = true
  # private_endpoint = {
  #   "pe_endpoint" = {
  #     private_dns_entry_enabled       = true
  #     dns_zone_virtual_network_link   = "dns_zone_link_openai"
  #     is_manual_connection            = false
  #     name                            = "openai_pe"
  #     private_service_connection_name = "openai_pe_connection"
  #     subnet_name                     = "subnet0"
  #     vnet_name                       = module.vnet.vnet_name
  #     vnet_rg_name                    = azurerm_resource_group.this.name
  #   }
  # }
}

module "openai" {
  source = "../../modules/openai"

  subscription_id               = local.subscription_id
  environment                   = local.environment
  resource_group_name           = azurerm_resource_group.librechat.name
  location                      = azurerm_resource_group.librechat.location
  public_network_access_enabled = true
  deployment                    = var.deployments

}
