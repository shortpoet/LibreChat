# IaC for LibreChat

## Deploy

```bash
# aws_assume_role
# export CLOUDFLARE_API_TOKEN=$(pass Cloud/cloudflare/Terraform_Token)
# export CLOUDFLARE_ACCOUNT_ID=$(pass Cloud/cloudflare/account_id)
az login
env='dev'
cd "/Users/Shared/source/repos/forks/LibreChat/.iac/infra_base/azure/envs/$env"
terraform init
terraform plan -out "$env.tfplan"
terraform apply  -auto-approve "$env.tfplan"
# terraform output -raw site_domain_root > ../site_domain_root.txt
# terraform output -raw site_domain_dev > ../site_domain_dev.txt
cd "/Users/Shared/source/repos/forks/LibreChat/.iac/infra_base/azure/envs/$env"
mongo_uri="$(pass Cloud/atlas/mongodb/soriano.carlos/LibreChat/connection_string)"
openai_api_key="$(pass Cloud/openai/ai-maps/dev/api_key)"
meili_master_key="$(pass Cloud/meili/LibreChat/dev/meili_master_key)"
jwt_secret="$(pass Deployments/LibreChat/dev/jwt_secret)"
jwt_refresh_secret="$(pass Deployments/LibreChat/dev/jwt_refresh_secret)"
github_client_id="$(pass Github/oauth/ai-maps/preview/GITHUB_CLIENT_ID)"
github_client_secret="$(pass Github/oauth/ai-maps/preview/GITHUB_CLIENT_SECRET)"
vars_to_check=(
  "mongo_uri"
  "openai_api_key"
  "meili_master_key"
  "jwt_secret"
  "jwt_refresh_secret"
  "github_client_id"
  "github_client_secret"
)

# Loop through the variable names and construct the var_string
var_string=''
for var in "${vars_to_check[@]}"; do
  var_string+=" -var=\"$var=${!var}\""
done
echo "$var_string"
terraform init
terraform plan -out "$env.tfplan" "$var_string"

# aws s3 cp website/ s3://$(cat site_domain_root.txt)/ --recursive --profile terraform-admin
# aws s3 cp shortpoet_site/ s3://$(cat site_domain_dev.txt)/ --recursive --profile terraform-admin
```

## tags

```bash
git tag -a v0.0.1 -m "first release"
git push --follow-tags
git tag -d v0.0.1
git push --delete origin v0.0.1
```
