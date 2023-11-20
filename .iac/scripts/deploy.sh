#!/usr/bin/env bash

set -e

provider="${1:-aws}"
env="${2:-dev}"
go_live="${3:-false}"

aws_profile='terraform-admin'

pass_azure_tenant='Azure/carlos@shortpoet/tenant_id'
pass_azure_subscription='Azure/carlos@shortpoet/subscriptions/shortpoet/id'

active_dir=$(pwd)
script_dir=$(dirname "$0")
repo_root=$(git rev-parse --show-toplevel)


# shellcheck disable=SC1091
. "$script_dir/aws_assume_role.sh"

[[ "$*" == *--help* ]] && {
  echo "Usage: $0 [provider] [env] [go_live]"
  echo "  provider: aws, gcp, azure"
  echo "  env: dev, prod"
  exit 0
}

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

echo -e "\nAsserting VARS for [${provider}] provider in [${env}] environment\n"

is_pass_unlocked="$(pass test/unlocked)"
echo "is_pass_unlocked: ${is_pass_unlocked}"

if [ "${is_pass_unlocked}" != "true" ]; then
  echo "Pass is locked. Please run 'pass unlock test/unlocked'"
  exit 1
fi

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
