FROM lsiobase/alpine:3.10

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="alex-phillips"

# environment settings
ENV HOME="/app"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache \
    nodejs \
    npm \
    ttf-freefont && \
 apk add --no-cache --virtual=build-dependencies \
    git && \
 echo "**** install shinobi ****" && \
 git clone --depth 1 --single-branch --branch dev https://gitlab.com/Shinobi-Systems/Shinobi.git /app/shinobi && \
 cd /app/shinobi && \
 /usr/bin/npm install && \
 /usr/bin/npm install \
    ffbinaries \
    sqlite3 && \
 echo "**** ensure abc user's home folder is /app ****" && \
 usermod -d /app abc && \
 echo "**** cleanup ****" && \
 apk del --purge \
    build-dependencies && \
 rm -rf \
    /root/.cache \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8000
