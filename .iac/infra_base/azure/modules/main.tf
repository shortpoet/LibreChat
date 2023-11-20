resource "azurerm_resource_group" "this" {
  name     = local.networking_resource_group_name
  location = local.location
}
