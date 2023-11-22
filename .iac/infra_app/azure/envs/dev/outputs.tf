# output "mongo_connection_string" {
#   description = "Connection string for the MongoDB"
#   value       = azurerm_cosmosdb_account.librechat.connection_strings[0]
#   sensitive = true
# }

output "ressource_group_name" {
  description = "name of the created ressource group"
  value       = azurerm_resource_group.librechat.name
}

output "libre_chat_url" {
  value = module.webapp.libre_chat_url
}

output "meilisearch_url" {
  value = module.webapp.meilisearch_url
}

output "azure_openai_api_key" {
  value     = module.openai.openai_primary_key
  sensitive = true
}

output "azure_openai_endpoint" {
  value     = module.openai.openai_endpoint
  sensitive = true
}

output "private_ip_addresses" {
  value = module.networking.private_ip_addresses
}
