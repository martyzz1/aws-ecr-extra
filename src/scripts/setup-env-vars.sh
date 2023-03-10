#!/usr/bin/env bash
# shellcheck disable=SC1073,SC1009
echo "export FULL_IMAGE_TAG='<< parameters.full-image-tag >>'" >> << parameters.env-var-file >>
echo "export REPO='<< parameters.repo >>'" >> << parameters.env-var-file >>
echo "export GIT_TAG='$(git rev-parse HEAD)'" >> << parameters.env-var-file >>
