# xmrig docker container

[![Docker Stars](https://img.shields.io/docker/stars/patsissons/xmrig.svg)](https://hub.docker.com/r/patsissons/xmrig/)[![Docker Pulls](https://img.shields.io/docker/pulls/patsissons/xmrig.svg)](https://hub.docker.com/r/patsissons/xmrig/)[![Docker Build Status](https://img.shields.io/docker/build/patsissons/xmrig.svg)](https://hub.docker.com/r/patsissons/xmrig/)

This container allows running [xmrig](https://github.com/xmrig/xmrig) in a docker container.

## Docker

This docker image in available on [docker hub](https://hub.docker.com/r/patsissons/xmrig/).

## Example

```bash
# run a dockerized miner
# -o and all following arguments are passed to the xmrig miner process
docker run -it -d --name xmrig patsissons/xmrig -o ca.minexmr.com:5555 --donate-level 1 -u 47NHecs6qjvDcbx3eW6cDGDwdm3gDqbHs7G8hzPYRxf3YRTcDJw8kXhDxfHinsjHUwVwdFusSn76UHkaz68KurUgHvFmPMH.github -p x
```

## Building

This image uses a multi-stage build, all that should be required is `docker build .` to build the latest image.

### Environment

You can adjust the following docker environment variables to customize the build process.

* `GIT_REPOSITORY`: use a custom git repo for `xmrig` (default is `https://github.com/xmrig/xmrig.git`)
* `XMRIG_CMAKE_FLAGS`: use custom cmake flags (default is empty)

You can adjust the following docker build args

* `DISTRO_NAME`: image to use for building and runtime (default is `alpine`)
* `DISTRO_VERSION`: image version to use for building and runtime (default is `latest`)

## Donations

If you find this docker image useful, donations for work on dockerizing the build and mining app are appreciated at any of the folllowing addresses:

* BTC: `1LNY9wSPs913Y9jXMTrrVze1E41nhm6Qv7`
* LTC: `LhnwdbrnQaQbjDkqxXFmxXGPcFhMBA9gFu`
* ETH: `a05c67acbec8afc30287704540b215284a7c21a9`
* XMR: `47NHecs6qjvDcbx3eW6cDGDwdm3gDqbHs7G8hzPYRxf3YRTcDJw8kXhDxfHinsjHUwVwdFusSn76UHkaz68KurUgHvFmPMH`
* XRP: `rG9vAB1rbgDW3Ds7HFqJeF9Pi4fGRbEs93`
