#!/usr/bin/env bash
# shellcheck disable=SC2129

MY_FULL_IMAGE_TAG=$(eval echo "${FULL_IMAGE_TAG}" | sed 's/[^a-z0-9.-]/-/g' )
MY_REPO=$(eval echo "${REPO}")

echo "export FULL_IMAGE_TAG=\"${MY_FULL_IMAGE_TAG}\"" >> "$ENV_VAR_FILENAME"
echo "export REPO=\"${MY_REPO}\"" >> "$ENV_VAR_FILENAME"
echo "export GIT_TAG=\"$(git rev-parse HEAD)\"" >> "$ENV_VAR_FILENAME"
