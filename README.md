# xmrig docker container

[![Docker Stars](https://img.shields.io/docker/stars/patsissons/xmrig.svg)](https://hub.docker.com/r/patsissons/xmrig/) [![Docker Pulls](https://img.shields.io/docker/pulls/patsissons/xmrig.svg)](https://hub.docker.com/r/patsissons/xmrig/) [![Docker Build Status](https://img.shields.io/docker/cloud/build/patsissons/xmrig.svg)](https://hub.docker.com/r/patsissons/xmrig/builds) [![Docker Layers](https://images.microbadger.com/badges/image/patsissons/xmrig.svg)](https://microbadger.com/images/patsissons/xmrig)

This container allows running [xmrig](https://github.com/xmrig/xmrig) in a docker container.

## Example

* A simple one liner to get the container mining right away

```bash
docker run -it -d --name xmrig patsissons/xmrig -o ca.minexmr.com:5555 -u 47NHecs6qjvDcbx3eW6cDGDwdm3gDqbHs7G8hzPYRxf3YRTcDJw8kXhDxfHinsjHUwVwdFusSn76UHkaz68KurUgHvFmPMH.github-xmrig -p x -a cn/r
```

* A more [comprehensive script](https://github.com/patsissons/xmrig-docker/blob/master/start-xmrig.sh) to simplify the process of starting and uprading the miner. Running `sudo ./start-xmrig.sh` will pull down the latest version while still mining, then stop and upgrade the container to resume mining with minimal downtime. If you want to use this
script with the latest `develop` builds, run `sudo ./start-xmrig.sh develop` instead. The script is ready to accept overrides for a few environment variables to simplify multi-host distribution.

|Environment Variable|Default Value|Notes|
|-|-|-|
|`ADDRESS`|N/A|make sure to replace the default with your own address or you will be mining to my address|
|`HOST`|`hostname -s`|override this if you want a custom host name that is different from your actual host name|
|`PORT`|`8080`|if another container or process is already using port `8080` this can be adjusted|
|`POOL_HOST`|N/A|make sure to replace this with your own pool remote uri|
|`POOL_USER`|`$ADDRESS.$HOST-$TAG`|adjust this to your needs|
|`POOL_PASS`|`x`|adjust this to your needs|
|`POOL_ALGO`|`cn/r`|algorithm to use, see [docs](https://github.com/xmrig/xmrig/blob/master/doc/ALGORITHMS.md#algorithm-names)|

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
* XMR: `47NHecs6qjvDcbx3eW6cDGDwdm3gDqbHs7G8hzPYRxf3YRTcDJw8kXhDxfHinsjHUwVwdFusSn76UHkaz68KurUgHvFmPMH`
