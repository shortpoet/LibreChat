resource "azurerm_cosmosdb_account" "librechat" {

  name                      = local.librechat_cosmosdb_name
  resource_group_name       = data.azurerm_resource_group.this.name
  location                  = data.azurerm_resource_group.this.location
  offer_type                = "Standard"
  kind                      = "MongoDB"
  enable_automatic_failover = false
  enable_free_tier          = var.use_cosmosdb_free_tier


  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    location          = data.azurerm_resource_group.this.location
    failover_priority = 0
  }
  capabilities {
    name = "MongoDBv3.4"
  }
  capabilities {
    name = "EnableServerless"
  }
  capabilities {
    name = "EnableMongo"
  }

  virtual_network_rule {
    id = local.cosmosdb_vnet_rule_subnet_id
  }

  # enable_multiple_write_locations = false
  is_virtual_network_filter_enabled = true
  public_network_access_enabled     = true
}
