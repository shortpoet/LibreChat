#!/usr/bin/env bash

set -e

ENVIRONMENT=$1
GO_LIVE=$2
RUN_INIT=${3:-false}

cur_dir="$(pwd)"

if [ -z "${ENVIRONMENT}" ] || [ -z "${GO_LIVE}" ]; then
  echo "Usage: ./deploy.sh <ENVIRONMENT> <GO_LIVE> <RUN_INIT>"
  exit 1
fi

if [ "${GO_LIVE}" != "true" ] && [ "${GO_LIVE}" != "false" ]; then
  echo "GO_LIVE must be true or false"
  exit 1
fi

declare -A secrets=(
  ["mongo_uri"]="Cloud/atlas/mongodb/soriano.carlos/LibreChat/connection_string"
  ["openai_api_key"]="Cloud/openai/ai-maps/dev/api_key"
  ["meili_master_key"]="Cloud/meili/LibreChat/dev/meili_master_key"
  ["jwt_secret"]="Deployments/LibreChat/dev/jwt_secret"
  ["jwt_refresh_secret"]="Deployments/LibreChat/dev/jwt_refresh_secret"
  ["github_client_id"]="Github/oauth/ai-maps/preview/GITHUB_CLIENT_ID"
  ["github_client_secret"]="Github/oauth/ai-maps/preview/GITHUB_CLIENT_SECRET"
)
get_secret_value() {
  pass "$1"
}
var_string=''
for secret_name in "${!secrets[@]}"; do
  secret_value=$(get_secret_value "${secrets[$secret_name]}")
  var_string+=" -var=\"$secret_name=$secret_value\""
done
# echo "var_string: ${var_string}"
cd "/Users/Shared/source/repos/forks/LibreChat/.iac/infra_app/azure/envs/$ENVIRONMENT"

if [ "${RUN_INIT}" == "true" ]; then
  terraform init
fi
# cmd="terraform import $var_string \"module.webapp.azurerm_linux_web_app.librechat\" \"subscriptions/060cfbfe-45ab-4a1c-84fc-c056e94221be/resourceGroups/librechat-dev/providers/Microsoft.Web/sites/librechatapp-dev\""
cmd="terraform plan $var_string -out $ENVIRONMENT.tfplan"
# cmd="terraform destroy $var_string -auto-approve"
# echo "$cmd"
eval "$cmd"

cd "$cur_dir"

# uri="https://management.azure.com/subscriptions/060cfbfe-45ab-4a1c-84fc-c056e94221be/providers/Microsoft.CognitiveServices/skus?api-version=2021-10-01"
# access_token=$(az account get-access-token --query accessToken --output tsv)
# headers="Authorization: Bearer $access_token"
# data=$(curl "$uri" -H "$headers" -H "Content-Type: application/json" )
# echo "$data" | jq -r '.value[] | select(.kind == "Open AI") | .name'