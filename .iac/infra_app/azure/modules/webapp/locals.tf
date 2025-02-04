locals {
  # Common
  subscription_id      = var.subscription_id
  environment          = var.environment
  location             = var.location
  default_tags_enabled = true
  tags                 = {}
  application_name     = "openai_service_librechat_${local.environment}"

  # App
  librechat_resource_group_name = "librechat-${local.environment}"
  app_title                     = "LibreChat-Shortpoet"

  # Networking
  app_service_subnet_id = var.app_service_subnet_id

  # App Service
  app_service_sku_name = var.app_service_sku_name

  # LibreChat App
  librechat_app_name = "librechatapp-${local.environment}"
  libre_chat_url     = "${azurerm_linux_web_app.librechat.name}.azurewebsites.net"
  librechat_app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
    HOST                     = "0.0.0.0"
    MONGO_URI                = var.mongo_uri
    OPENAI_API_KEY           = var.openai_api_key
    DEBUG_OPENAI             = var.debug_openai
    DEBUG_PLUGINS            = var.debug_plugins
    CHECK_BALANCE            = var.check_balance
    MEILI_MASTER_KEY         = random_string.meilisearch_master_key.result
    MEILI_HOST               = "${azurerm_linux_web_app.meilisearch.name}.azurewebsites.net"
    SEARCH                   = true
    MEILI_NO_ANALYTICS       = true

    APP_TITLE = local.app_title

    AZURE_API_KEY                                = var.azure_api_key
    AZURE_OPENAI_API_INSTANCE_NAME               = try(split("//", split(".", var.azure_openai_endpoint)[0])[1], "")
    AZURE_OPENAI_API_DEPLOYMENT_NAME             = var.azure_openai_api_deployment_name != "" ? var.azure_openai_api_deployment_name : (contains(keys(var.deployment), "chat_model") ? var.deployment.chat_model.name : "")
    AZURE_OPENAI_API_VERSION                     = var.azure_openai_api_version
    AZURE_OPENAI_API_COMPLETIONS_DEPLOYMENT_NAME = var.azure_openai_api_completions_deployment_name != "" ? var.azure_openai_api_completions_deployment_name : (contains(keys(var.deployment), "chat_model") ? var.deployment.chat_model.name : "")
    AZURE_OPENAI_API_EMBEDDINGS_DEPLOYMENT_NAME  = var.azure_openai_api_embeddings_deployment_name != "" ? var.azure_openai_api_embeddings_deployment_name : (contains(keys(var.deployment), "embedding_model") ? var.deployment.embedding_model.name : "")

    CHATGPT_TOKEN  = var.chatgpt_token
    CHATGPT_MODELS = "text-davinci-002-render-sha,gpt-4"

    ANTHROPIC_API_KEY = var.anthropic_api_key
    ANTHROPIC_MODELS  = "claude-1,claude-instant-1,claude-2"

    BINGAI_TOKEN = var.bingai_token

    GOOGLE_API_KEY = ""
    GOOGLE_CSE_ID  = ""

    PALM_KEY = var.palm_key

    PLUGIN_MODELS = "gpt-3.5-turbo,gpt-3.5-turbo-16k,gpt-3.5-turbo-0301,gpt-4,gpt-4-0314,gpt-4-0613"

    CREDS_KEY = var.plugin_creds_key
    CREDS_IV  = var.plugin_creds_iv

    JWT_SECRET         = var.jwt_secret
    JWT_REFRESH_SECRET = var.jwt_refresh_secret
    DOMAIN_SERVER      = "http://localhost:3535"
    DOMAIN_CLIENT      = "http://localhost:3535"

    GITHUB_CLIENT_ID     = var.github_client_id
    GITHUB_CLIENT_SECRET = var.github_client_secret
    GITHUB_CALLBACK_URL  = "/oauth/github/callback"

    EMAIL_SERVICE = var.email_service
    EMAIL_USER    = var.email_user
    EMAIL_PASS    = var.email_pass
    EMAIL_FROM    = var.email_from

    VITE_SHOW_GOOGLE_LOGIN_OPTION = false
    ALLOW_REGISTRATION            = true
    ALLOW_SOCIAL_LOGIN            = true
    ALLOW_SOCIAL_REGISTRATION     = true

    SESSION_EXPIRY = (1000 * 60 * 60 * 24) * 7

    DOCKER_REGISTRY_SERVER_URL          = "https://index.docker.io"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    DOCKER_ENABLE_CI                    = false
    WEBSITES_PORT                       = 80
    PORT                                = 80
    DOCKER_CUSTOM_IMAGE_NAME            = "ghcr.io/shortpoet/librechat-dev-api:latest"
    NODE_ENV                            = "production"
  }

  # MeiliSearch
  meilisearch_app_name = "meilisearchapp-${local.environment}"
  meilisearch_url      = "${azurerm_linux_web_app.meilisearch.name}.azurewebsites.net"
  meilisearch_app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false

    MEILI_MASTER_KEY   = random_string.meilisearch_master_key.result
    MEILI_NO_ANALYTICS = true

    DOCKER_REGISTRY_SERVER_URL          = "https://index.docker.io"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    DOCKER_ENABLE_CI                    = false
    WEBSITES_PORT                       = 7700
    PORT                                = 7700
    DOCKER_CUSTOM_IMAGE_NAME            = "getmeili/meilisearch:latest"
  }

}
