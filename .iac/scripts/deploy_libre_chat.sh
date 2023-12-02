#!/usr/bin/env bash

set -e

ENVIRONMENT=$1
GO_LIVE=$2
RUN_INIT=${3:-false}

if [ -z "${ENVIRONMENT}" ] || [ -z "${GO_LIVE}" ]; then
  echo "Usage: ./deploy.sh <ENVIRONMENT> <GO_LIVE> <RUN_INIT>"
  exit 1
fi

if [ "${GO_LIVE}" != "true" ] && [ "${GO_LIVE}" != "false" ]; then
  echo "GO_LIVE must be true or false"
  exit 1
fi

# app
title='Shortpoet-LibreChat'
port=3080
domain_client='http://0.0.0.0:3080'
domain_server='http://0.0.0.0:3080'
host='0.0.0.0'
# chat
check_balance=false
debug_openai=true
debug_plugins=true
proxy=''
# search
search=true
meili_master_key=''
# auth
allow_registration=true
# Allow Social Registration
allow_social_login=false
allow_social_registration=false
jwt_secret=''
jwt_refresh_secret=''
session_expiry=$((1000 * 60 * 15))
refresh_token_expiry=$(((1000 * 60 * 60 * 24) * 7))
github_client_id=''
github_client_secret=''
github_callback_url='/oauth/github/callback' # this should be the same for everyone
# Email is used for password reset. Note that all 4 values must be set for email to work.
# Failing to set the 4 values will result in LibreChat using the unsecured password reset!
email_service='' # eg. gmail
email_username='' # eg. your email address if using gmail
email_password='' # eg. this is the "app password" if using gmail
email_from='' # email address for from field, it is required to set a value here even in the cases where it's not porperly working.


echo -e "\nAsserting VARS for ${ENVIRONMENT} environment\n"

is_pass_unlocked="$(pass test/unlocked)"
echo "is_pass_unlocked: ${is_pass_unlocked}"

if [ "${is_pass_unlocked}" != "true" ]; then
  echo "Pass is locked. Please run 'pass unlock test/unlocked'"
  exit 1
fi

mongo_uri="$(pass Cloud/atlas/mongodb/librechat/furtive-fox-88/connection_string)"
# openai_api_key="user_provided"
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

for var in "${vars_to_check[@]}"; do
  if [ -z "${!var}" ]; then
    echo "Missing ${var} in pass"
    exit 1
  else
    echo "${var} is set"
  fi
done

files_to_check=(
  "./meilisearch"
)

echo -e "\nAsserting FILES for ${ENVIRONMENT} environment\n"

for file in "${files_to_check[@]}"; do
  if [ ! -f "${file}" ]; then
    echo "Missing ${file}"
    exit 1
  else
    echo "${file} exists"
  fi
done

if [ "${GO_LIVE}" == "false" ]; then
  echo -e "\nGO_LIVE is false. Exiting.\n"
  exit 0
fi

echo -e "\nDeploying to ${ENVIRONMENT} environment\n"

if [ "${RUN_INIT}" == "true" ]; then
  echo -e "\nRunning init\n"
  npm ci
  APP_TITLE=${title} npm run frontend
fi

# check if meilisearch is executable
if [ ! -x "$(command -v ./meilisearch)" ]; then
  echo "meilisearch is not executable"
  sudo chmod +x ./meilisearch
fi

if [ -x "$(command -v ./meilisearch)" ]; then
  echo -e "\nStarting meilisearch\n"
  ./meilisearch --master-key "${meili_master_key}" &
fi

echo -e "\nStarting backend\n"

APP_TITLE=${title} \
  HOST=${host} \
  PORT=${port} \
  CHECK_BALANCE=${check_balance} \
  MONGO_URI=${mongo_uri} \
  OPENAI_API_KEY=${openai_api_key} \
  DEBUG_OPENAI=${debug_openai} \
  DEBUG_PLUGINS=${debug_plugins} \
  PROXY=${proxy} \
  DOMAIN_CLIENT=${domain_client} \
  DOMAIN_SERVER=${domain_server} \
  SEARCH=${search} \
  MEILI_MASTER_KEY=${meili_master_key} \
  ALLOW_REGISTRATION=${allow_registration} \
  ALLOW_SOCIAL_LOGIN=${allow_social_login} \
  ALLOW_SOCIAL_REGISTRATION=${allow_social_registration} \
  JWT_SECRET=${jwt_secret} \
  JWT_REFRESH_SECRET=${jwt_refresh_secret} \
  SESSION_EXPIRY=${session_expiry} \
  REFRESH_TOKEN_EXPIRY=${refresh_token_expiry} \
  GITHUB_CLIENT_ID=${github_client_id} \
  GITHUB_CLIENT_SECRET=${github_client_secret} \
  GITHUB_CALLBACK_URL=${github_callback_url} \
  EMAIL_SERVICE=${email_service} \
  EMAIL_USERNAME=${email_username} \
  EMAIL_PASSWORD=${email_password} \
  EMAIL_FROM=${email_from} \
  npm run backend
