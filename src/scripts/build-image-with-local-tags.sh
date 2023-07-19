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

number_of_tags_in_ecr=0
docker_tag_args=""

echo "ORB_EVAL_TAGS=$ORB_EVAL_TAGS"

IFS="," read -ra DOCKER_TAGS <<< "$ORB_EVAL_TAGS"

for tag in "${DOCKER_TAGS[@]}"; do
  my_tag=$(eval echo "${tag}" | sed 's/[^a-z0-9.-]/-/g' )

  if [ "$ORB_ENV_SKIP_TAG_EXISTS" = "1" ]; then
	docker_tag_exists_in_ecr=$(aws ecr describe-images --profile "$ORB_ENV_PROFILE" --registry-id "$ORB_ENV_REGISTRY_ID" --repository-name "$ORB_EVAL_REPO" --query "contains(imageDetails[].imageTags[], '$my_tag')")
	if [ "$docker_tag_exists_in_ecr" = "true" ]; then
	  docker pull "$ORB_VAL_ACCOUNT_URL/$ORB_EVAL_REPO:${my_tag}"
	  ((number_of_tags_in_ecr+=1))
	  echo "number_of_tags_in_ecr=$number_of_tags_in_ecr"
	fi
  fi
  docker_tag_args="$docker_tag_args -t $ORB_EVAL_REPO:$my_tag"
done

echo "ORB_ENV_EXTRA_BUILD_ARGS=$ORB_ENV_EXTRA_BUILD_ARGS"
echo "ORB_ENV_DOCKER_PATH=$ORB_ENV_DOCKER_PATH"
echo "ORB_ENV_DOCKERILE=$ORB_ENV_DOCKERILE"
echo "ORB_ENV_SKIP_TAG_EXISTS=$ORB_ENV_SKIP_TAG_EXISTS"
echo "ORB_EVAL_TAGS=$ORB_EVAL_TAG"
echo "docker_tag_args=$docker_tag_args"
echo "number_of_tags_in_ecr=$number_of_tags_in_ecr"

if [ "$ORB_ENV_SKIP_TAG_EXISTS" = "0" ] || [ "$ORB_ENV_SKIP_TAG_EXISTS" = "1" ] && [ $number_of_tags_in_ecr -lt ${#DOCKER_TAGS[@]} ]; then

  #shellcheck disable=2086
  docker build \
	$ORB_ENV_EXTRA_BUILD_ARGS\
	-f "$ORB_ENV_DOCKER_PATH/$ORB_ENV_DOCKERILE" \
	$docker_tag_args \
	"$ORB_ENV_DOCKER_PATH"
fi
