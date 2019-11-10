ARG DISTRO_NAME=alpine
ARG DISTRO_VERSION=latest

FROM ${DISTRO_NAME}:${DISTRO_VERSION} as build

ENV GIT_REPOSITORY=https://github.com/xmrig/xmrig.git \
    GIT_BRANCH=v3.2.0
ENV CMAKE_FLAGS=

COPY donate-level.patch /tmp

WORKDIR /tmp

RUN  set -x \
  && apk update \
  && apk add --no-cache ca-certificates git build-base cmake libuv-dev libmicrohttpd-dev openssl-dev util-linux-dev \
  && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted hwloc-dev \
  && git clone --single-branch --depth 1 --branch $GIT_BRANCH $GIT_REPOSITORY xmrig \
  && git -C xmrig apply ../donate-level.patch \
  && cd xmrig \
  && cmake ${CMAKE_FLAGS} . \
  && make \
  && rm -rf /var/cache/apk/*

FROM ${DISTRO_NAME}:${DISTRO_VERSION}

RUN  set -x \
  && adduser -S -D -h /config miner \
  && apk update \
  && apk upgrade \
  && apk add --no-cache libuv libmicrohttpd openssl util-linux \
  && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted hwloc \
  && rm -rf /var/lib/{apt,dpkg,cache,log}

COPY --from=build /tmp/xmrig/xmrig /usr/local/bin/

USER miner

WORKDIR /config
VOLUME /config

ENTRYPOINT ["xmrig"]

CMD ["--help"]
