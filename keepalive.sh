#!/bin/bash
# Keep-alive script for BlobeVM on Render
# Sends periodic pings to prevent service suspension

set -e

PORT="${PORT:-3000}"
KEEP_ALIVE_INTERVAL="${KEEP_ALIVE_INTERVAL:-300}"  # 5 minutes
HEALTH_URL="http://localhost:${PORT}/"
STARTUP_DELAY=15

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

health_check() {
    local status
    status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "${HEALTH_URL}" 2>/dev/null || echo "000")

    if [ "$status" = "200" ]; then
        log "✓ Health check passed (HTTP $status)"
        return 0
    else
        log "✗ Health check failed (HTTP $status)"
        return 1
    fi
}

log "Starting keep-alive service"
log "Target URL: $HEALTH_URL"
log "Check interval: ${KEEP_ALIVE_INTERVAL}s"
log "Waiting ${STARTUP_DELAY}s for BlobeVM to initialize..."

sleep "$STARTUP_DELAY"

while true; do
    log "Performing health check..."
    health_check || true
    log "Next check in ${KEEP_ALIVE_INTERVAL}s"
    sleep "$KEEP_ALIVE_INTERVAL"
done
