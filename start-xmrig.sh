#!/bin/bash

TAG=${1:-latest}
ADDRESS=${ADDRESS:-47NHecs6qjvDcbx3eW6cDGDwdm3gDqbHs7G8hzPYRxf3YRTcDJw8kXhDxfHinsjHUwVwdFusSn76UHkaz68KurUgHvFmPMH}
HOST=${HOST:-$(hostname -s)}
PORT=${PORT:-8080}
POOL_HOST=${POOL:-ca.minexmr.com:5555}
POOL_USER=${POOL_USER:-$ADDRESS.$HOST-$TAG}
POOL_PASS=${POOL_PASS:-x}
POOL_ALGO=${POOL_ALGO:-cn/r}

docker pull patsissons/xmrig:$TAG && \
docker rm -f xmrig-$TAG 2> /dev/null && \
docker run -it -d --name xmrig-$TAG -p $PORT:8080 patsissons/xmrig:$TAG -o $POOL_HOST -u $POOL_USER -p $POOL_PASS -a $POOL_ALGO --api-port 8080
