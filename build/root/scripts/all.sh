#!/bin/sh

rp=$(dirname $0)

. $rp/config.sh && . $rp/clone.sh && . $rp/build.sh && . $rp/dist.sh
