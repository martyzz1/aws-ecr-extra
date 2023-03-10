#!/usr/bin/env bash
# shellcheck disable=SC2129

eval echo "export FULL_IMAGE_TAG=\"${FULL_IMAGE_TAG}\"" >> "$ENV_VAR_FILENAME"
eval echo "export REPO=\"${REPO}\"" >> "$ENV_VAR_FILENAME"
echo "export GIT_TAG=\"$(git rev-parse HEAD)\"" >> "$ENV_VAR_FILENAME"
