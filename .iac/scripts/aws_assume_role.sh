#!/usr/bin/env bash

aws_assume_role () {

  AWS_ACCESS_KEY_ID="$(pass Amazon/AWS-shortpoet/terraform-user/AWS_ACCESS_KEY_ID)"
  AWS_SECRET_ACCESS_KEY="$(pass Amazon/AWS-shortpoet/terraform-user/AWS_SECRET_ACCESS_KEY)"
  AWS_DEFAULT_REGION="us-east-1"
  export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION

  region="us-east-1"
  role="${1:-terraform-admin}"
  account_id="$(aws sts get-caller-identity --query Account --output text)"
  arn="arn:aws:iam::$account_id:role/$role"
  sessionName="$(hostname)-$(date +%F+%H.%M)"
  aws_credentials=$(\
    AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    aws sts assume-role --role-arn "$arn" --role-session-name "$sessionName" \
  )
  unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
  role_alias="$role"
  aws configure --profile "$role_alias" set "profile.$role_alias.aws_access_key_id" "$(echo "$aws_credentials" | jq -r '.Credentials.AccessKeyId')"
  aws configure --profile "$role_alias" set "profile.$role_alias.aws_secret_access_key" "$(echo "$aws_credentials" | jq -r '.Credentials.SecretAccessKey')"
  aws configure --profile "$role_alias" set "profile.$role_alias.aws_session_token" "$(echo "$aws_credentials" | jq -r '.Credentials.SessionToken')"
  echo "Assumed role --> $(echo "$aws_credentials" | jq -r '.AssumedRoleUser.Arn')"
}
