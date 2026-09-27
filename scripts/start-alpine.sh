#!/bin/bash

# starts the alpine and alpine-static images as app:alpine and app:alpine-static
# any extra arguments are passed to docker container

set -e

cd "$(dirname "$0")/.."

VARIANT=${VARIANT:-alpine-static}

docker run -it --rm --name "app-${VARIANT}" app:${VARIANT} "$@"
