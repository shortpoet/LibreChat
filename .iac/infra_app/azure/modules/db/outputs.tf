output "mongo_connection_string" {
  description = "Connection string for the MongoDB"
  value       = azurerm_cosmosdb_account.librechat.connection_strings[0]
  sensitive   = true
}
