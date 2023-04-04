#!/bin/bash

if [ -z "${!ORB_ENV_REGISTRY_ID}" ]; then
  echo "The registry ID is not found. Please add the registry ID as an environment variable in CicleCI before continuing."
  exit 1
fi

#shellcheck disable=SC2153
ORB_VAL_REGION=$(eval echo "${ORB_EVAL_REGION}")
#shellcheck disable=SC2153
ORB_VAL_TAGS=$(eval echo "${ORB_EVAL_TAGS}")
ORB_VAL_ACCOUNT_URL="${!ORB_ENV_REGISTRY_ID}.dkr.ecr.${ORB_VAL_REGION}.amazonaws.com"

IFS="," read -ra DOCKER_TAGS <<< "$ORB_VAL_TAGS"
for tag in "${DOCKER_TAGS[@]}"; do
	echo "Tagging with tag $tag"
	echo "repo $ORB_ENV_REPO"
	echo "account-url $ORB_VAL_ACCOUNT_URL"
	docker tag "$ORB_ENV_REPO:${tag}" "$ORB_VAL_ACCOUNT_URL/$ORB_ENV_REPO:${tag}"
done
