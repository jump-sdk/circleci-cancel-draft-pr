#!/usr/bin/env bash

required_env_vars=(
              "GITHUB_TOKEN"
              "CIRCLE_TOKEN"
            )

for required_env_var in ${required_env_vars[@]}; do
  if [[ -z "${!required_env_var}" ]]; then
    printf "${required_env_var} not provided, but that doesn't mean we should skip CI.\n"
    exit 0
  fi
done

# Since we're piggybacking off of an existing OAuth var, tweak the var for our uses
token=$(printf "${GITHUB_TOKEN}" | cut -d':' -f1)

headers="Authorization: token $token"
api_endpoint="https://api.github.com/repos/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/pulls/${CIRCLE_PULL_REQUEST##*/}"

# Fetch PR metadata from Github's API and parse fields from json
github_res=$(curl --silent --header "${headers}" "${api_endpoint}" | jq '{draft: .draft, title: .title}')
draft=$(printf "${github_res}" | jq '.draft')
title=$(printf "${github_res}" | jq '.title' | tr '[:upper:]' '[:lower:]')

if [[ "${title}" == "null" && "${draft}" == "null" ]]; then
  printf "Couldn't fetch info on PR, but that doesn't mean we should skip CI.\n"
  exit 0
fi

cancel_running_jobs=0

if [[ "${draft}" == true ]]; then
  printf "PR is a draft, skipping CI!\n"
  cancel_running_jobs=1
fi

for skip_token in '[skip ci]' '[ci skip]' '[wip]'; do
  if [[ ${title} == *"${skip_token}"* ]]; then
    printf "Found \"${skip_token}\" in PR title, skipping CI!\n"
    cancel_running_jobs=1
  fi
done

if [[ "${cancel_running_jobs}" == 1 ]]; then
  curl -X POST https://circleci.com/api/v2/workflow/${CIRCLE_WORKFLOW_ID}/cancel -H 'Accept: application/json' -u "${CIRCLE_TOKEN}:"
  echo 'Cancel'
else
  printf "No reason to skip CI, let's go!"
fi
exit 0
