resource "azurerm_virtual_network" "librechat_network" {
  name                = local.librechat_vnet_name
  address_space       = local.librechat_vnet_address_space
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "librechat_subnet" {
  name                 = local.librechat_subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.librechat_network.name
  address_prefixes     = local.librechat_subnet_address_prefixes

  service_endpoints = ["Microsoft.AzureCosmosDB", "Microsoft.Web"]

  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}
