FROM alpine

ENV REPO_URI=https://github.com/xmrig/xmrig.git \
    DIST_PATH=/xmrig

COPY root /

WORKDIR /build

CMD [ "/bin/sh", "/scripts/all.sh" ]
