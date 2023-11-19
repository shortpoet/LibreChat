# IaC for LibreChat

## Deploy

```bash
aws_assume_role
export CLOUDFLARE_API_TOKEN=$(pass Cloud/cloudflare/Terraform_Token)
export CLOUDFLARE_ACCOUNT_ID=$(pass Cloud/cloudflare/account_id)
cd aws
terraform init
terraform apply
terraform output -raw site_domain_root > ../site_domain_root.txt
terraform output -raw site_domain_dev > ../site_domain_dev.txt
cd ..
aws s3 cp website/ s3://$(cat site_domain_root.txt)/ --recursive --profile terraform-admin
aws s3 cp shortpoet_site/ s3://$(cat site_domain_dev.txt)/ --recursive --profile terraform-admin
```

## tags

```bash
git tag -a v0.0.1 -m "first release"
git push --follow-tags
git tag -d v0.0.1
git push --delete origin v0.0.1
```
