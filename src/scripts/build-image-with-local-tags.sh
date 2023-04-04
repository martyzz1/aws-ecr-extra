#!/bin/bash
ORB_EVAL_REGION=$(eval echo "${ORB_EVAL_REGION}")

if [ -z "${!ORB_ENV_REGISTRY_ID}" ]; then
  echo "The registry ID is not found. Please add the registry ID as an environment variable in CicleCI before continuing."
  exit 1
fi

ORB_VAL_ACCOUNT_URL="${!ORB_ENV_REGISTRY_ID}.dkr.ecr.${ORB_EVAL_REGION}.amazonaws.com"
number_of_tags_in_ecr=0
docker_tag_args=""

IFS="," read -ra DOCKER_TAGS <<< "$ORB_ENV_TAGS"

for tag in "${DOCKER_TAGS[@]}"; do
  my_tag=$(eval echo "${tag}" | sed 's/[^a-z0-9.-]/-/g' )

  if [ "$ORB_ENV_SKIP_TAG_EXISTS" = "true" ]; then
	docker_tag_exists_in_ecr=$(aws ecr describe-images --profile "$ORB_ENV_PROFILE" --registry-id "$ORB_ENV_REGISTRY_ID" --repository-name "$ORB_ENV_REPO" --query "contains(imageDetails[].imageTags[], '$my_tag')")
	if [ "$docker_tag_exists_in_ecr" = "true" ]; then
	  docker pull "$ORB_VAL_ACCOUNT_URL/$ORB_ENV_REPO:${my_tag}"
	  ((number_of_tags_in_ecr+=1))
	  echo "number_of_tags_in_ecr=$number_of_tags_in_ecr"
	fi
  fi
  docker_tag_args="$docker_tag_args -t $ORB_ENV_REPO:$my_tag"
done

if [ "$ORB_ENV_SKIP_TAG_EXISTS" = "false" ] || [ "$ORB_ENV_SKIP_TAG_EXISTS" = "true" ] && [ $number_of_tags_in_ecr -lt ${#DOCKER_TAGS[@]} ]; then

  echo "ORB_ENV_EXTRA_BUILD_ARGS=$ORB_ENV_EXTRA_BUILD_ARGS"
  echo "ORB_ENV_DOCKER_PATH=$ORB_ENV_DOCKER_PATH"
  echo "ORB_ENV_DOCKERILE=$ORB_ENV_DOCKERILE"
  echo "docker_tag_args=$docker_tag_args"
  #shellcheck disable=2086
  docker build \
	$ORB_ENV_EXTRA_BUILD_ARGS\
	-f "$ORB_ENV_DOCKER_PATH/$ORB_ENV_DOCKERILE" \
	$docker_tag_args \
	"$ORB_ENV_DOCKER_PATH"
fi
