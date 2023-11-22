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

  pe_private_connection_resource_id = module.openai.openai_account_id
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

  depends_on = [azurerm_resource_group.librechat]

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

  account_name = local.cognitive_account_name
  deployment   = local.openai_deployment

  public_network_access_enabled = local.public_network_access_enabled
  custom_subdomain_name         = local.cognitive_account_custom_subdomain_name

  depends_on = [azurerm_resource_group.librechat]

}

module "webapp" {
  source = "../../modules/webapp"

  subscription_id      = local.subscription_id
  environment          = local.environment
  location             = azurerm_resource_group.librechat.location
  resource_group_name  = azurerm_resource_group.librechat.name
  default_tags_enabled = local.default_tags_enabled
  tags                 = local.tags
  application_name     = local.application_name

  app_service_subnet_id         = data.terraform_remote_state.infra_base.outputs.subnet.id
  public_network_access_enabled = local.public_network_access_enabled

  deployment            = local.openai_deployment
  azure_api_key         = module.openai.openai_primary_key
  azure_openai_endpoint = module.openai.openai_endpoint

  depends_on = [azurerm_resource_group.librechat]

}
