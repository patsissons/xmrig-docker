ARG DISTRO_NAME=alpine
ARG DISTRO_VERSION=latest

FROM ${DISTRO_NAME}:${DISTRO_VERSION} as build

ENV GIT_REPOSITORY https://github.com/xmrig/xmrig.git
ENV XMRIG_CMAKE_FLAGS=

COPY root /

WORKDIR /build

RUN  apk update \
  && apk upgrade \
  && apk add --no-cache ca-certificates git build-base cmake libuv-dev libmicrohttpd-dev openssl-dev util-linux-dev \
  && git clone $GIT_REPOSITORY /build/xmrig \
  && git -C xmrig apply ../donate-level.patch \
  && cd xmrig \
  && cmake ${XMRIG_CMAKE_FLAGS} . \
  && make \
  && rm -rf /var/cache/apk/*

FROM ${DISTRO_NAME}:${DISTRO_VERSION}

COPY --from=build /build/xmrig/xmrig /usr/local/bin/

RUN  adduser -S -D -H -h /xmrig xmrig \
  && apk update \
  && apk upgrade \
  && apk add --no-cache libuv libmicrohttpd openssl util-linux \
  && rm -rf /var/cache/apk/*

USER xmrig

ENTRYPOINT [ "xmrig" ]
CMD [ "--version" ]
