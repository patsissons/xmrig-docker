#!/bin/bash

TAG=${1:-latest}
ADDRESS=${ADDRESS:-47NHecs6qjvDcbx3eW6cDGDwdm3gDqbHs7G8hzPYRxf3YRTcDJw8kXhDxfHinsjHUwVwdFusSn76UHkaz68KurUgHvFmPMH}
HOST=${HOST:-$(hostname -s)}

REMOTE=${REMOTE:-pool.supportxmr.com:7777}
REMOTE_USER=${REMOTE_USER:-$ADDRESS}
REMOTE_PASS=${REMOTE_PASS:-$HOST:patricksissons@gmail.com}

NAME=${NAME:-xmrig-$TAG}

# setup msr
# see: https://xmrig.com/docs/miner/randomx-optimization-guide/msr
modprobe msr
if cat /proc/cpuinfo | grep "AMD Ryzen" > /dev/null; then
    echo "Detected Ryzen"
    wrmsr -a 0xc0011022 0x510000
    wrmsr -a 0xc001102b 0x1808cc16
    wrmsr -a 0xc0011020 0
    wrmsr -a 0xc0011021 0x40
    echo "MSR register values for Ryzen applied"
elif cat /proc/cpuinfo | grep "Intel" > /dev/null; then
    echo "Detected Intel"
    wrmsr -a 0x1a4 0xf
    echo "MSR register values for Intel applied"
else
    echo "No supported CPU detected"
fi

# setup 1GB huge pages
# see: https://xmrig.com/docs/miner/hugepages
# make sure you also setup huge page support by running the command below
#   sysctl -w vm.nr_hugepages=1280
# or by updating /etc/sysctl.conf
#   echo vm.nr_hugepages = 1280 >> /etc/sysctl.conf
# a restart may be required after setting up huge page support
for i in $(find /sys/devices/system/node/node* -maxdepth 0 -type d); do
    echo 3 > "$i/hugepages/hugepages-1048576kB/nr_hugepages";
done

# pull latest, remove existing container by same name, stop other running xmrig containers
docker pull patsissons/xmrig:$TAG && \
docker ps -aq --filter name=$NAME | xargs --no-run-if-empty docker rm -f && \
docker ps -aq --filter name=xmrig --filter status=running | xargs --no-run-if-empty docker stop

# start new container
set -ex && \
docker run \
  --privileged -d --restart always --user root \
  -it --name $NAME \
  -v xmrig-config:/config \
  -v /lib/modules:/lib/modules:ro \
  --runtime=nvidia \
  --device /dev/dri --device /dev/kfd --group-add=video \
  patsissons/xmrig:$TAG \
  -o $REMOTE -u $REMOTE_USER -p $REMOTE_PASS -k \
  --cuda --opencl --randomx-1gb-pages --no-nvml --print-time=60 --health-print-time=60
