resource "azurerm_resource_group" "librechat" {
  name     = local.librechat_resource_group_name
  location = local.location
}

# module "networking" {

#   source = "../../modules/networking"

#   subscription_id      = local.subscription_id
#   environment          = local.environment
#   location             = azurerm_resource_group.librechat.location
#   resource_group_name  = azurerm_resource_group.librechat.name
#   default_tags_enabled = local.default_tags_enabled
#   tags                 = local.tags
#   application_name     = local.application_name

#   pe_private_connection_resource_id = module.openai.openai_account_id
#   # private_endpoint = {
#   #   "pe_endpoint" = {
#   #     private_dns_entry_enabled       = true
#   #     dns_zone_virtual_network_link   = "dns_zone_link_openai"
#   #     is_manual_connection            = false
#   #     name                            = "openai_pe"
#   #     private_service_connection_name = "openai_pe_connection"
#   #     subnet_name                     = "subnet0"
#   #     vnet_name                       = module.vnet.vnet_name
#   #     vnet_rg_name                    = azurerm_resource_group.this.name
#   #   }
#   # }

#   depends_on = [azurerm_resource_group.librechat]

# }

# module "openai" {
#   source = "../../modules/openai"

#   subscription_id      = local.subscription_id
#   environment          = local.environment
#   location             = azurerm_resource_group.librechat.location
#   resource_group_name  = azurerm_resource_group.librechat.name
#   default_tags_enabled = local.default_tags_enabled
#   tags                 = local.tags
#   application_name     = local.application_name

#   account_name = local.cognitive_account_name
#   deployment   = local.openai_deployment

#   public_network_access_enabled = local.public_network_access_enabled
#   custom_subdomain_name         = local.cognitive_account_custom_subdomain_name

#   depends_on = [azurerm_resource_group.librechat]

# }

module "webapp" {
  source = "../../modules/webapp"

  subscription_id      = local.subscription_id
  environment          = local.environment
  location             = azurerm_resource_group.librechat.location
  resource_group_name  = azurerm_resource_group.librechat.name
  default_tags_enabled = local.default_tags_enabled
  tags                 = local.tags
  application_name     = local.application_name

  app_service_sku_name = local.app_service_sku_name
  deployment           = local.openai_deployment
  debug_openai         = local.debug_openai
  debug_plugins        = local.debug_plugins
  mongo_uri            = local.mongo_uri
  meili_master_key     = local.meili_master_key
  jwt_secret           = local.jwt_secret
  jwt_refresh_secret   = local.jwt_refresh_secret
  # azure_api_key         = module.openai.openai_primary_key
  # azure_openai_endpoint = module.openai.openai_endpoint
  openai_api_key       = local.openai_api_key
  check_balance        = local.check_balance
  github_client_id     = local.github_client_id
  github_client_secret = local.github_client_secret
  email_service        = local.email_service
  email_user           = local.email_user
  email_pass           = local.email_password
  email_from           = local.email_from

  app_service_subnet_id         = data.terraform_remote_state.infra_base.outputs.subnet.id
  public_network_access_enabled = local.public_network_access_enabled


  depends_on = [azurerm_resource_group.librechat]

}
