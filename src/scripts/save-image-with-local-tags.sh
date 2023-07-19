#!/bin/bash

ORB_EVAL_REPO=$(eval echo "${ORB_EVAL_REPO}")
ORB_EVAL_TAG=$(eval echo "${ORB_EVAL_TAG}")
ORB_ENV_IMAGE_FILE=$(eval echo "${ORB_ENV_IMAGE_FILE}")
ORB_EVAL_TAGS=$(eval echo "${ORB_EVAL_TAG}" | tr '[:upper:]' '[:lower:]' | tr '/' '-')

TAGS=()

echo "ORB_EVAL_TAGS=$ORB_EVAL_TAGS"
IFS="," read -ra DOCKER_TAGS <<< "$ORB_EVAL_TAGS"
for tag in "${DOCKER_TAGS[@]}"; do
  my_tag=$(eval echo "${tag}" | sed 's/[^a-z0-9.-]/-/g' )
  TAGS+=("$ORB_EVAL_REPO:$my_tag")
done

docker save --output "$ORB_ENV_IMAGE_FILE" "${TAGS[@]}"
