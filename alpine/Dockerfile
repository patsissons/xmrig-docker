ARG ALPINE_VERSION=latest
ARG GIT_REPOSITORY=https://github.com/xmrig/xmrig.git
ARG GIT_BRANCH=v5.3.0

FROM alpine:${ALPINE_VERSION} AS build

ARG GIT_REPOSITORY
ARG GIT_BRANCH

ENV GIT_REPOSITORY=${GIT_REPOSITORY} \
    GIT_BRANCH=${GIT_BRANCH}
ENV CMAKE_FLAGS "-DWITH_OPENCL=OFF -DWITH_CUDA=OFF"

COPY donate-level.patch /tmp

WORKDIR /tmp

RUN  set -x \
  && apk update \
  && apk add --no-cache ca-certificates git build-base cmake libmicrohttpd-dev libuv-dev openssl-dev util-linux-dev \
  && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ --allow-untrusted numactl-dev \
  && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted hwloc-dev \
  && git clone --single-branch --depth 1 --branch $GIT_BRANCH $GIT_REPOSITORY xmrig \
  && git -C xmrig apply /tmp/donate-level.patch \
  && cd xmrig \
  && cmake ${CMAKE_FLAGS} . \
  && make \
  && rm -rf /var/cache/apk/*

FROM alpine:${ALPINE_VERSION}

RUN  set -x \
  && adduser -S -D -h /config miner \
  && apk update \
  && apk upgrade \
  && apk add --no-cache libmicrohttpd libuv openssl util-linux \
  && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ --allow-untrusted numactl \
  && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted hwloc \
  && rm -rf /var/lib/{apt,dpkg,cache,log}

COPY --from=build /tmp/xmrig/xmrig /usr/local/bin/

USER miner

WORKDIR /config
VOLUME /config

ENTRYPOINT ["/usr/local/bin/xmrig"]

CMD ["--help"]
