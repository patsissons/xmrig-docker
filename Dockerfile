ARG CUDA_VERSION=10.1
ARG CUDA_UBUNTU_VERSION=16.04
ARG AMDGPU_VERSION=17.40-514569
ARG GIT_REPOSITORY=https://github.com/xmrig/xmrig.git
ARG GIT_BRANCH=v4.6.2-beta

FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${CUDA_UBUNTU_VERSION} AS build-cuda

ARG GIT_REPOSITORY_CUDA
ARG GIT_BRANCH_CUDA

ENV DEBIAN_FRONTEND=noninteractive \
    GIT_REPOSITORY=https://github.com/xmrig/xmrig-cuda.git \
    GIT_BRANCH=v2.0.0-beta
ENV CMAKE_FLAGS "-DCUDA_LIB=/usr/local/cuda/lib64/stubs/libcuda.so -DCMAKE_CXX_FLAGS=-std=c++11"
ENV PACKAGE_DEPS "build-essential cmake git"

WORKDIR /tmp

RUN  set -x \
  && apt-get update -qq \
  && apt-get install -qq --no-install-recommends -y ${PACKAGE_DEPS} \
  && git clone --single-branch --depth 1 --branch $GIT_BRANCH $GIT_REPOSITORY xmrig-cuda \
  && cd xmrig-cuda \
  && cmake ${CMAKE_FLAGS} . \
  && make \
  && apt-get purge -qq -y ${PACKAGE_DEPS} \
  && apt-get autoremove -qq -y \
  && apt-get clean autoclean -qq -y

FROM ubuntu:${CUDA_UBUNTU_VERSION} AS build

ARG GIT_REPOSITORY
ARG GIT_BRANCH

ENV DEBIAN_FRONTEND=noninteractive \
    GIT_REPOSITORY=${GIT_REPOSITORY} \
    GIT_BRANCH=${GIT_BRANCH}
ENV CMAKE_FLAGS "-DWITH_OPENCL=ON -DWITH_CUDA=ON -DWITH_NVML=ON"
ENV PACKAGE_DEPS "build-essential ca-certificates cmake git libhwloc-dev libmicrohttpd-dev libssl-dev libuv1-dev ocl-icd-opencl-dev"

COPY donate-level.patch /tmp

WORKDIR /tmp

RUN  set -x \
  && dpkg --add-architecture i386 \
  && apt-get update -qq \
  && apt-get install -qq --no-install-recommends -y ${PACKAGE_DEPS} \
  && git clone --single-branch --depth 1 --branch $GIT_BRANCH $GIT_REPOSITORY xmrig \
  && git -C xmrig apply /tmp/donate-level.patch \
  && cd xmrig \
  && cmake ${CMAKE_FLAGS} . \
  && make \
  && apt-get purge -qq -y ${PACKAGE_DEPS} \
  && apt-get autoremove -qq -y \
  && apt-get clean autoclean -qq -y \
  && rm -rf /var/lib/{apt,dpkg,cache,log}

FROM nvidia/cuda:${CUDA_VERSION}-runtime-ubuntu${CUDA_UBUNTU_VERSION}

ARG CUDA_UBUNTU_VERSION
ARG AMDGPU_VERSION

ENV DEBIAN_FRONTEND=noninteractive \
    LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}
ENV AMDGPU_DRIVER_NAME=amdgpu-pro-${AMDGPU_VERSION}
ENV AMDGPU_DRIVER_URI=https://www2.ati.com/drivers/linux/ubuntu/${AMDGPU_DRIVER_NAME}.tar.xz
ENV PACKAGE_DEPS "ca-certificates libhwloc5 libmicrohttpd10 libssl1.0.0 libuv1 wget xz-utils"

RUN set -x \
  && adduser --system --disabled-password --home /config miner \
  && dpkg --add-architecture i386 \
  && apt-get update -qq \
  && apt-get install -qq --no-install-recommends -y ${PACKAGE_DEPS} \
  && wget -q --show-progress --progress=bar:force:noscroll --referer https://support.amd.com ${AMDGPU_DRIVER_URI} \
  && tar -xvf ${AMDGPU_DRIVER_NAME}.tar.xz \
  && SUDO_FORCE_REMOVE=yes apt-get -y remove --purge wget xz-utils \
  && rm -f ${AMDGPU_DRIVER_NAME}.tar.xz \
  && chmod +x ./${AMDGPU_DRIVER_NAME}/amdgpu-pro-install \
  && ./${AMDGPU_DRIVER_NAME}/amdgpu-pro-install -y \
  && rm -rf ${AMDGPU_DRIVER_NAME} \
  && rm -rf /var/opt/amdgpu-pro-local \
  && apt-get -qq -y autoremove \
  && apt-get -qq -y clean autoclean \
  && rm -rf /var/lib/{apt,dpkg,cache,log}

COPY --from=build /tmp/xmrig/xmrig /usr/local/bin/
COPY --from=build-cuda /tmp/xmrig-cuda/libxmrig-cuda.so /usr/local/lib

USER miner

WORKDIR /config
VOLUME /config

ENTRYPOINT ["/usr/local/bin/xmrig"]

CMD ["--help"]
