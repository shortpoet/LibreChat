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

current_dir="$(pwd)"
current_dir_leaf="${PWD##*/}"
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
iac_dir="${script_dir}/.."
root_dir="${iac_dir}/.."

echo "current_dir: ${current_dir}"
echo "current_dir_leaf: ${current_dir_leaf}"
echo "script_dir: ${script_dir}"
echo "iac_dir: ${iac_dir}"
echo "root_dir: ${root_dir}"

current_branch="$(git rev-parse --abbrev-ref HEAD)"

# TODO double check this
current_tag="$(git describe --tags --abbrev=0)"

next_tag="$(echo "${current_tag}" | awk -F'.' '{print $1"."$2"."$3+1}')"
next_branch=${next_tag//./}
has_changes="$(git status --porcelain)"
if [ -n "${has_changes}" ]; then
  echo "You have uncommitted changes, please commit or stash them before bumping"
  exit 1
fi
echo "current branch: ${current_branch}"
echo "current tag: ${current_tag}"
echo "next tag: ${next_tag}"
echo "next branch: ${next_branch}"

if [ "${GO_LIVE}" == "true" ]; then
  # ask user to confirm
  read -p "Are you sure you want to bump to ${next_tag}? [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborting"
    exit 1
  fi
  cd "${root_dir}"

  echo "GO_LIVE is true, bumping tag to ${next_tag}"
  # git checkout "${next_tag}"
  # git checkout -b "${next_branch}"

  # git checkout "${current_branch}" -- .iac
  # git checkout "${current_branch}" -- worker
  # git checkout "${current_branch}" -- .gitignore
  # git checkout "${current_branch}" -- .eslintrc.js
  # git checkout "${current_branch}" -- prettier.config.js
  # git checkout "${current_branch}" -- package.json
  # git checkout "${current_branch}" -- package-lock.json
  # git checkout "${current_branch}" -- client/tailwind.config.cjs

  git add .
  git commit -m "Bump to ${next_tag}"
  git push origin "${next_branch}"

  # cd "${current_dir}"
  # git difftool "${current_branch}" "${next_branch}"
  echo "Bump complete, please review the changes and push to origin"
  echo "git merge --no-ff ${next_branch}"
fi
