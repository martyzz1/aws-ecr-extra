#!/bin/bash

ORB_EVAL_REPO=$(eval echo "${ORB_EVAL_REPO}")
ORB_EVAL_TAG=$(eval echo "${ORB_EVAL_TAG}")
ORB_EVAL_REGION=$(eval echo "${ORB_EVAL_REGION}")
ORB_VAL_ACCOUNT_URL="${!ORB_ENV_REGISTRY_ID}.dkr.ecr.${ORB_EVAL_REGION}.amazonaws.com"

if [ -z "${!ORB_ENV_REGISTRY_ID}" ]; then
  echo "The registry ID is not found. Please add the registry ID as an environment variable in CicleCI before continuing."
  exit 1
fi

if [ "$ORB_EVAL_REGION" == "us-east-1" ]; then
	echo "ORB_EVAL_REGION 1 is 'east'"
fi
if [ "$ORB_EVAL_REGION" == "eu-west-1" ]; then
	echo "ORB_EVAL_REGION 2 is 'west'"
else
	echo "ORB_EVAL_REGION 3 is Weird"
fi

IFS="," read -ra DOCKER_TAGS <<< "${ORB_EVAL_TAG}"
for tag in "${DOCKER_TAGS[@]}"; do
	echo "Tagging with tag \"$ORB_EVAL_REPO:${tag}\" \"$ORB_VAL_ACCOUNT_URL/$ORB_EVAL_REPO:${tag}\""
	docker tag "$ORB_EVAL_REPO:${tag}" "$ORB_VAL_ACCOUNT_URL/$ORB_EVAL_REPO:${tag}"
done
