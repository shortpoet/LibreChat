resource "azurerm_service_plan" "librechat" {
  name                = local.librechat_app_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  os_type             = "Linux"

  sku_name = local.app_service_sku_name
}

resource "azurerm_linux_web_app" "librechat" {
  name                          = local.librechat_app_name
  location                      = azurerm_resource_group.this.location
  resource_group_name           = azurerm_resource_group.this.name
  service_plan_id               = azurerm_service_plan.librechat.id
  public_network_access_enabled = true
  https_only                    = true
  app_settings                  = local.librechat_app_settings
  virtual_network_subnet_id     = azurerm_subnet.librechat_subnet.id

  site_config {
    minimum_tls_version = "1.2"
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
    application_logs {
      file_system_level = "Information"
    }
  }
}

#  Deploy code from a public GitHub repo
# resource "azurerm_app_service_source_control" "sourcecontrol" {
#   app_id                 = azurerm_linux_web_app.librechat.id
#   repo_url               = "https://github.com/danny-avila/LibreChat"
#   branch                 = "main"    
#   type = "Github"

#   # use_manual_integration = true
#   # use_mercurial          = false
#   depends_on = [
#     azurerm_linux_web_app.librechat,
#   ]
# }

# resource "azurerm_app_service_virtual_network_swift_connection" "librechat" {
#   app_service_id = azurerm_linux_web_app.librechat.id
#   subnet_id      = module.vnet.vnet_subnets_name_id["subnet0"]

#   depends_on = [
#     azurerm_linux_web_app.librechat,
#     module.vnet
#   ]
# }

#TODO: privately communicate between librechat and meilisearch, right now it is via public internet
resource "azurerm_linux_web_app" "meilisearch" {
  name                = local.meilisearch_app_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  service_plan_id     = azurerm_service_plan.librechat.id
  app_settings        = local.meilisearch_app_settings

  site_config {
    always_on = "true"
    ip_restriction {
      virtual_network_subnet_id = azurerm_subnet.librechat_subnet.id
      priority                  = 100
      name                      = "Allow from LibreChat subnet"
      action                    = "Allow"
    }
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
    application_logs {
      file_system_level = "Information"
    }
  }

  # identity {
  #   type = "SystemAssigned"
  # }

}
