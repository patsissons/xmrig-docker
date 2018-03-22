#!/bin/sh

apt-get update
apk upgrade
apk add --no-cache ca-certificates git build-base cmake libuv-dev libmicrohttpd-dev util-linux-dev
