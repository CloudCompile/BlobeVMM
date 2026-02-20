# syntax=docker/dockerfile:1.4
# Ultra-optimized multi-stage Dockerfile for GitHub Codespace (2 core, 8GB RAM, 32GB storage)
# Lubuntu (LXQt) for maximum speed and performance
# Build with: DOCKER_BUILDKIT=1 docker build -t blobevm-optimized .

# Stage 1: Build dependencies (optimized for speed)
FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy AS builder

ARG DEBIAN_FRONTEND="noninteractive"
ARG BUILD_DATE
ARG VERSION

# Set build labels
LABEL build_version="[Ultra-Optimized Lubuntu] Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="blobevm-ultra-optimized"
LABEL description="Ultra-fast Lubuntu (LXQt) desktop optimized for GitHub Codespace"

# Configure APT for maximum performance during build
RUN echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages && \
    echo 'Acquire::GzipIndexes "true";' > /etc/apt/apt.conf.d/docker-gzip-indexes && \
    echo 'Acquire::CompressionTypes::Order:: "gz";' >> /etc/apt/apt.conf.d/docker-gzip-indexes && \
    echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/docker-assume-yes && \
    echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/docker-no-recommends && \
    echo 'APT::Install-Suggests "false";' >> /etc/apt/apt.conf.d/docker-no-recommends && \
    echo 'Acquire::Retries "3";' > /etc/apt/apt.conf.d/docker-retries && \
    echo 'Acquire::http::Timeout "15";' >> /etc/apt/apt.conf.d/docker-retries && \
    echo 'Acquire::https::Timeout "15";' >> /etc/apt/apt.conf.d/docker-retries

# Stage 2: Runtime image with Lubuntu optimizations
FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

ARG DEBIAN_FRONTEND="noninteractive"

# Copy build optimizations from builder
COPY --from=builder /etc/apt/apt.conf.d/* /etc/apt/apt.conf.d/

# Set optimized labels for runtime
LABEL build_version="[Ultra-Optimized Lubuntu] Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="blobevm-ultra-optimized"
LABEL description="Ultra-fast Lubuntu (LXQt) desktop optimized for GitHub Codespace"

# prevent Ubuntu's firefox stub from being installed
COPY /root/etc/apt/preferences.d/firefox-no-snap /etc/apt/preferences.d/firefox-no-snap

# Copy application files
COPY options.json /
COPY /root/ /

# Ultra-optimized installation for maximum speed with progress indication
RUN echo "🚀 Installing ultra-optimized Lubuntu (LXQt) for GitHub Codespace" && \
    # Ensure bundled scripts are executable (repo may not preserve +x)
    chmod +x /installapps.sh /install-de.sh /startwm-*.sh /installable-apps/*.sh /etc/cont-init.d/* && \
    # Update package lists once
    apt-get update && \
    # Add Mozilla PPA for optimized Firefox
    add-apt-repository -y ppa:mozillateam/ppa && \
    apt-get update && \
    # Add Google Chrome repository
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    # Install Lubuntu (LXQt) and essential apps in single layer for speed
    # (force-confold/force-confdef prevents dpkg conffile prompts when this repo pre-seeds configs like /etc/wgetrc)
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        -o Dpkg::Options::="--force-confdef" \
        -o Dpkg::Options::="--force-confold" \
        # Audio system packages for microphone support
        pulseaudio \
        pulseaudio-utils \
        alsa-utils \
        alsa-base \
        alsa-oss \
        pavucontrol \
        # Lubuntu (LXQt) Core - lightweight and fastest
        lxqt \
        lubuntu-default-settings \
        qterminal \
        featherpad \
        # Essential apps optimized for Codespace
        firefox \
        google-chrome-stable \
        jq \
        wget \
        curl \
        ca-certificates \
        # Wine prerequisites for EXE support
        wine64 \
        wine32 \
        libwine \
        wine \
        # Package management tools
        gdebi \
        synaptic \
        # Performance and development tools
        htop \
        nano \
        vim \
        unzip \
        zip \
        tree && \
    # Install additional apps based on options.json
    /installapps.sh && \
    # Apply ultra-optimizations for Lubuntu (LXQt)
    echo "⚡ Applying ultra-optimizations for maximum speed" && \
    # Keep upstream XDG autostart entries (some are required for a stable session).
    : && \
    # Copy optimized start script
    cp /startwm-lxqt.sh /defaults/startwm.sh && \
    chmod +x /defaults/startwm.sh && \
    # Aggressive cleanup for minimal image size and faster builds
    echo "🧹 Aggressive cleanup for maximum speed" && \
    apt-get autoclean && \
    apt-get clean && \
    rm -rf \
      /config/.cache \
      /var/lib/apt/lists/* \
      /var/cache/apt/archives/* \
      /var/tmp/* \
      /tmp/* \
      /root/.cache \
      /var/cache/ldconfig \
      /var/log/* \
      /root/.bash_history \
      /root/.viminfo \
      /root/.wget-hsts \
      /root/.python_history \
      /root/.node_repl_history \
      /root/.npm \
      /root/.yarn-cache \
      /root/.cache && \
    # nginx requires /var/log/nginx to exist
    mkdir -p /var/log/nginx && \
    touch /var/log/nginx/access.log /var/log/nginx/error.log

# Expose optimized port and audio ports
EXPOSE 3000
EXPOSE 4713

# Set optimized volume
VOLUME /config

# Health check for optimized performance
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -fsS http://localhost:3000 >/dev/null 2>&1 || curl -fkSs https://localhost:3000 >/dev/null 2>&1 || exit 1
