#!/bin/bash

ORB_EVAL_REPO=$(eval echo "${ORB_EVAL_REPO}")
ORB_EVAL_TAG=$(eval echo "${ORB_EVAL_TAG}")
ORB_EVAL_REGION=$(eval echo "${ORB_EVAL_REGION}")
ORB_VAL_ACCOUNT_URL="${!ORB_ENV_REGISTRY_ID}.dkr.ecr.${ORB_EVAL_REGION}.amazonaws.com"
ORB_EVAL_TAGS=$(eval echo "${ORB_EVAL_TAG}" | tr '[:upper:]' '[:lower:]' | tr '/' '-')

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

IFS="," read -ra DOCKER_TAGS <<< "${ORB_EVAL_TAGS}"
for tag in "${DOCKER_TAGS[@]}"; do
	my_tag=$(eval echo "${tag}" | sed 's/[^a-z0-9.-]/-/g' )

	echo "Tagging with tag \"$ORB_EVAL_REPO:${my_tag}\" \"$ORB_VAL_ACCOUNT_URL/$ORB_EVAL_REPO:${my_tag}\""
	docker tag "$ORB_EVAL_REPO:${my_tag}" "$ORB_VAL_ACCOUNT_URL/$ORB_EVAL_REPO:${my_tag}"
done
