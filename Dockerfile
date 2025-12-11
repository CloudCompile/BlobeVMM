# syntax=docker/dockerfile:1.4
# Enable BuildKit for better build performance
# Build with: DOCKER_BUILDKIT=1 docker build -t blobevm .

FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="[Mollomm1 Mod] Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="mollomm1"

ARG DEBIAN_FRONTEND="noninteractive"

# Configure APT for better performance and parallel downloads
RUN echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages && \
    echo 'Acquire::GzipIndexes "true";' > /etc/apt/apt.conf.d/docker-gzip-indexes && \
    echo 'Acquire::CompressionTypes::Order:: "gz";' >> /etc/apt/apt.conf.d/docker-gzip-indexes && \
    echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/docker-assume-yes && \
    echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/docker-no-recommends && \
    echo 'APT::Install-Suggests "false";' >> /etc/apt/apt.conf.d/docker-no-recommends && \
    echo 'Acquire::Retries "3";' > /etc/apt/apt.conf.d/docker-retries && \
    echo 'Acquire::http::Timeout "10";' >> /etc/apt/apt.conf.d/docker-retries && \
    echo 'Acquire::https::Timeout "10";' >> /etc/apt/apt.conf.d/docker-retries

# prevent Ubuntu's firefox stub from being installed
COPY /root/etc/apt/preferences.d/firefox-no-snap /etc/apt/preferences.d/firefox-no-snap

COPY options.json /

COPY /root/ /

# Combine installation steps for better layer caching and reduced build time
RUN echo "**** install packages and configure system ****" && \
  add-apt-repository -y ppa:mozillateam/ppa && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    firefox \
    jq \
    wget \
    curl \
    ca-certificates && \
  chmod +x /install-de.sh && \
  /install-de.sh && \
  chmod +x /installapps.sh && \
  /installapps.sh && \
  rm /installapps.sh && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  apt-get clean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/cache/apt/archives/* \
    /var/tmp/* \
    /tmp/* \
    /root/.cache
  
# ports and volumes
EXPOSE 3000
VOLUME /config
