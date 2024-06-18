#!/usr/bin/env bash
# shellcheck disable=SC2129
GIT_TAG=$(git rev-parse HEAD)
MY_BRANCH_NAME_OR_TAG=$CIRCLE_TAG

if [ "$CIRCLE_TAG" == "" ]; then
	BUILD_TAG_SHA1=$GIT_TAG
	MY_BRANCH_NAME_OR_TAG=$CIRCLE_BRANCH
else
	BUILD_TAG_SHA1=$CIRCLE_TAG
fi

MY_BRANCH_NAME_OR_TAG=$(echo "${MY_BRANCH_NAME_OR_TAG}" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9.-]/-/g' )
MY_FULL_IMAGE_TAG=$(eval echo "${FULL_IMAGE_TAG}" | sed 's/[^a-z0-9.-]/-/g' )
MY_REPO=$(eval echo "${REPO}")

echo "export FULL_IMAGE_TAG=\"${MY_FULL_IMAGE_TAG}\"" >> "$ENV_VAR_FILENAME"
echo "export REPO=\"${MY_REPO}\"" >> "$ENV_VAR_FILENAME"
echo "export GIT_TAG=\"$(git rev-parse HEAD)\"" >> "$ENV_VAR_FILENAME"
echo "export BUILD_TAG_SHA1=\"${BUILD_TAG_SHA1}\"" >> "$ENV_VAR_FILENAME"
echo "export BRANCH_NAME_TAG=\"${MY_BRANCH_NAME_OR_TAG}\"" >> "$ENV_VAR_FILENAME"
