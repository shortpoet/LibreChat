output "resource_group_name" {
  description = "name of the created ressource group"
  value       = azurerm_resource_group.networking.name
}

output "vnet" {
  value = module.networking.vnet
}

output "subnet" {
  value = module.networking.subnet
}

output "private_dns_zone" {
  value = module.networking.private_dns_zone
}
