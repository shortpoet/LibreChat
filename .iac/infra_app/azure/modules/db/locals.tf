locals {
  # Common
  subscription_id     = var.subscription_id
  environment         = var.environment
  location            = var.location
  resource_group_name = var.resource_group_name

  # Cosmos DB
  librechat_cosmosdb_name = "librechatdb-shortpoet"
}
