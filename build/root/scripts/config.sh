#!/bin/sh

apk upgrade
apk add --no-cache ca-certificates git build-base cmake libuv-dev libmicrohttpd-dev openssl-dev util-linux-dev
