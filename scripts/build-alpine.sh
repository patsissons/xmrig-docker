#!/bin/bash

# builds the alpine and alpine-static images as app:alpine and app:alpine-static
# any extra arguments are passed to docker build (e.g. --platform linux/amd64)

set -ex

cd "$(dirname "$0")/.."

BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

for VARIANT in alpine alpine-static; do
  docker build \
    -f $VARIANT/Dockerfile \
    --build-arg BUILD_DATE=$BUILD_DATE \
    -t app:$VARIANT \
    "$@" .
done
