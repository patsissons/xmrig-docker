ARG ALPINE_VERSION=latest
ARG GIT_REPOSITORY=https://github.com/xmrig/xmrig.git
ARG GIT_BRANCH=v6.26.0

FROM alpine:${ALPINE_VERSION} AS build

ARG GIT_REPOSITORY
ARG GIT_BRANCH

ENV GIT_REPOSITORY=${GIT_REPOSITORY} \
    GIT_BRANCH=${GIT_BRANCH}
ENV CMAKE_FLAGS "-DCMAKE_BUILD_TYPE=Release -DWITH_OPENCL=OFF -DWITH_CUDA=OFF -DWITH_NVML=OFF -DWITH_EMBEDDED_CONFIG=ON"

COPY donate-level.patch default-pool.patch /tmp/

WORKDIR /tmp

RUN  set -x \
  && apk update \
  && apk add --no-cache ca-certificates git build-base cmake libmicrohttpd-dev libuv-dev openssl-dev util-linux-dev linux-headers \
  && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ --allow-untrusted numactl-dev \
  && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted hwloc-dev \
  && git clone --single-branch --depth 1 --branch $GIT_BRANCH $GIT_REPOSITORY xmrig \
  && git -C xmrig apply -C1 /tmp/donate-level.patch \
  && git -C xmrig apply /tmp/default-pool.patch \
  && cd xmrig \
  && cmake ${CMAKE_FLAGS} . \
  && make \
  && rm -rf /var/cache/apk/* \
  && cp xmrig /tmp/app

FROM alpine:${ALPINE_VERSION}

ARG BUILD_DATE

LABEL org.label-schema.build-date="${BUILD_DATE}"

RUN  set -x \
  && apk update \
  && apk upgrade \
  && apk add --no-cache libmicrohttpd libuv openssl util-linux \
  && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ --allow-untrusted numactl \
  && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted hwloc \
  && rm -rf /var/lib/{apt,dpkg,cache,log}

COPY --from=build /tmp/app /usr/local/bin/
COPY ../config.json /usr/local/bin/config.json

WORKDIR /config
VOLUME /config

ENTRYPOINT ["/usr/local/bin/app"]

CMD ["--help"]
