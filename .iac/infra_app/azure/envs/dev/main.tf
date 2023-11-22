resource "azurerm_resource_group" "librechat" {
  name     = local.librechat_resource_group_name
  location = local.location
}

module "networking" {

  source = "../../modules/networking"

  subscription_id      = local.subscription_id
  environment          = local.environment
  location             = azurerm_resource_group.librechat.location
  resource_group_name  = azurerm_resource_group.librechat.name
  default_tags_enabled = local.default_tags_enabled
  tags                 = local.tags
  application_name     = local.application_name

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

  subscription_id      = local.subscription_id
  environment          = local.environment
  location             = azurerm_resource_group.librechat.location
  resource_group_name  = azurerm_resource_group.librechat.name
  default_tags_enabled = local.default_tags_enabled
  tags                 = local.tags
  application_name     = local.application_name

  public_network_access_enabled = local.public_network_access_enabled
  deployment                    = local.openai_deployment

}
