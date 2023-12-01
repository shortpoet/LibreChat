#!/usr/bin/env bash

set -e

provider="${1:-aws}"
env="${2:-dev}"
go_live="${3:-false}"

[[ "$*" == *--help* ]] && {
  echo "Usage: $0 [provider] [env] [go_live]"
  echo "  provider: aws, gcp, azure"
  echo "  env: dev, prod"
  exit 0
}


active_dir=$(pwd)
script_dir=$(dirname "$0")
repo_root=$(git rev-parse --show-toplevel)

# shellcheck disable=SC1091
. "$script_dir/aws_assume_role.sh"

[[ "$provider" != "aws" && "$provider" != "gcp" && "$provider" != "azure" ]] && {
  echo "Usage: $0 [provider] [env] [go_live]"
  echo "  provider: aws, gcp, azure"
  echo "  env: dev, prod"
  exit 1
}

[[ "$go_live" == "true" ]] && {
  echo "Going live"
}

[[ "$provider" != "aws" ]] && [[ "$provider" != "azure" ]] && {
  echo "Only AWS is supported at this time"
  exit 1
}

is_pass_unlocked="$(pass test/unlocked)"
echo "is_pass_unlocked: ${is_pass_unlocked}"

if [ "${is_pass_unlocked}" != "true" ]; then
  echo "Pass is locked. Please run 'pass unlock test/unlocked'"
  exit 1
fi

echo -e "\nAsserting VARS for [${provider}] provider in [${env}] environment\n"

aws_profile='terraform-admin'

# mongo_string="$(pass Cloud/atlas/mongodb/soriano.carlos/LibreChat/connection_string)"
# # openai_api_key="user_provided"
# openai_api_key="$(pass Cloud/openai/ai-maps/dev/api_key)"
# meili_master_key="$(pass Cloud/meili/LibreChat/dev/meili_master_key)"
# jwt_secret="$(pass Deployments/LibreChat/dev/jwt_secret)"
# jwt_refresh_secret="$(pass Deployments/LibreChat/dev/jwt_refresh_secret)"
# github_client_id="$(pass Github/oauth/ai-maps/preview/GITHUB_CLIENT_ID)"
# github_client_secret="$(pass Github/oauth/ai-maps/preview/GITHUB_CLIENT_SECRET)"

pass_azure_tenant='Azure/carlos@shortpoet/tenant_id'
pass_azure_subscription='Azure/carlos@shortpoet/subscriptions/shortpoet/id'

pass_plugins_creds_key="Deployments/LibreChat/$env/plugins_creds_key"
pass_plugins_creds_iv="Deployments/LibreChat/$env/plugins_creds_iv"

pass_mongo_string="Cloud/atlas/mongodb/soriano.carlos/LibreChat/connection_string"
pass_openai_api_key="Cloud/openai/ai-maps/$env/api_key"

pass_meili_master_key="Cloud/meili/LibreChat/$env/meili_master_key"

pass_jwt_secret="Deployments/LibreChat/$env/jwt_secret"
pass_jwt_refresh_secret="Deployments/LibreChat/$env/jwt_refresh_secret"

pass_github_client_id="Github/oauth/ai-maps/preview/GITHUB_CLIENT_ID"
pass_github_client_secret="Github/oauth/ai-maps/preview/GITHUB_CLIENT_SECRET"


vars_to_check=(
  "mongo_string"
  "openai_api_key"
  "meili_master_key"
  "jwt_secret"
  "jwt_refresh_secret"
  "github_client_id"
  "github_client_secret"
)

for var in "${vars_to_check[@]}"; do
  check="pass_$var"
  echo -e "\nChecking ${!check}"
  secret=$(pass "${!check}")
  if [[ -z "$secret" ]]; then
    echo "Missing ${var} in pass -> generating"
    length=64
    [[ "$check" == "pass_plugins_creds_iv" ]] && length=16
    secret=$(pass generate -n "$secret" "$length")
    # exit 1
  else
    echo "${var} is set"
  fi
done

login_aws() {
  aws sts get-caller-identity --profile "$aws_profile" >/dev/null || \
    { echo "Provider credentials not found -> assuming role"; aws_assume_role; }
}

login_azure() {
  azure_tenant_id=$(pass "$pass_azure_tenant")
  azure_sub_id=$(pass "$pass_azure_subscription")
  az account show >/dev/null || \
    { az login --tenant "$azure_tenant_id"; echo "Provider credentials not found -> logging in"; }
  az account set --subscription "$azure_sub_id"
}

provider_credentials_check() {
  CLOUDFLARE_API_TOKEN=$(pass Cloud/cloudflare/Terraform_Token)
  export CLOUDFLARE_API_TOKEN
  "login_$provider"
}

provider_credentials_check

[[ "$go_live" = "false" ]] && {
  echo "Dry run"
  exit 0
}

echo "Deploying to $provider/$env"

cd "$repo_root/.iac/$provider/envs/$env/infra"
terraform init
terraform apply

site_domain=$(terraform output -raw site_domain)
website_bucket_id=$(terraform output -json s3 | jq -r .website_bucket_id)

cd "$repo_root/app"
npm run build

[[ "$provider" == "aws" ]] && {
  aws s3 cp --recursive --acl public-read --profile "$aws_profile" ./dist "s3://$website_bucket_id"
}

[[ "$provider" == "azure" ]] && {
  az storage blob upload-batch --account-name "$website_bucket_id" --destination "$website_bucket_id" --source ./dist
}

cd "$active_dir"
