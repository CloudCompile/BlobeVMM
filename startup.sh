#!/bin/bash
# Startup script for Render deployment
# Ensures all services are properly initialized

set -e

echo "🚀 Starting BlobeVM on Render..."

# Source the linuxserver.io entry script
if [ -f /init ]; then
    echo "Initializing linuxserver.io environment..."
    exec /init
else
    echo "⚠️  /init not found, attempting direct VNC server start..."
    # Fallback: start the VNC server directly
    if [ -f /usr/bin/vncserver ]; then
        /usr/bin/vncserver :0 -geometry 1920x1080 -depth 24
    fi

    # Keep the container running
    while true; do
        sleep 60
    done
fi
