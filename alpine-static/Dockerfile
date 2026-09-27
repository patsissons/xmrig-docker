ARG ALPINE_VERSION=latest
ARG GIT_REPOSITORY=https://github.com/xmrig/xmrig.git
ARG GIT_BRANCH=v6.26.0

# static build, see: https://xmrig.com/docs/miner/build/alpine
FROM alpine:${ALPINE_VERSION} AS build

ARG GIT_REPOSITORY
ARG GIT_BRANCH

ENV GIT_REPOSITORY=${GIT_REPOSITORY} \
    GIT_BRANCH=${GIT_BRANCH}
ENV CMAKE_FLAGS="-DCMAKE_BUILD_TYPE=Release -DXMRIG_DEPS=scripts/deps -DBUILD_STATIC=ON -DWITH_OPENCL=OFF -DWITH_CUDA=OFF -DWITH_NVML=OFF"
ENV PACKAGE_DEPS="git make cmake libstdc++ gcc g++ automake libtool autoconf linux-headers"

COPY donate-level.patch /tmp

WORKDIR /tmp

# -C1 reduces patch context so it still applies after upstream comment changes in donate.h
RUN  set -x \
  && apk add --no-cache ${PACKAGE_DEPS} \
  && git clone --single-branch --depth 1 --branch $GIT_BRANCH $GIT_REPOSITORY xmrig \
  && git -C xmrig apply -C1 /tmp/donate-level.patch \
  && mkdir xmrig/build \
  && cd xmrig/scripts \
  && ./build_deps.sh \
  && cd ../build \
  && cmake .. ${CMAKE_FLAGS} \
  && make -j$(nproc) \
  && strip xmrig

FROM alpine:${ALPINE_VERSION}

ARG BUILD_DATE
ARG GIT_BRANCH
ARG VCS_REF

LABEL org.label-schema.build-date="${BUILD_DATE}" \
      org.label-schema.name="xmrig" \
      org.label-schema.description="xmrig static for alpine" \
      org.label-schema.url="https://github.com/patsissons/xmrig-docker/blob/master/README.md" \
      org.label-schema.vcs-url="https://github.com/patsissons/xmrig-docker" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.version="${GIT_BRANCH}-alpine-static"

COPY --from=build /tmp/xmrig/build/xmrig /usr/local/bin/

WORKDIR /config
VOLUME /config

ENTRYPOINT ["/usr/local/bin/xmrig"]

CMD ["--help"]
