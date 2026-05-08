#!/usr/bin/env python3
"""
Keep-alive service for Render deployment.
Periodically pings the BlobeVM application to prevent sleep/suspension.
"""

import time
import urllib.request
import urllib.error
import os
import sys
from datetime import datetime

KEEP_ALIVE_INTERVAL = int(os.getenv('KEEP_ALIVE_INTERVAL', '300'))  # 5 minutes
PORT = os.getenv('PORT', '3000')
LOCALHOST = 'http://localhost'
HEALTH_URL = f'{LOCALHOST}:{PORT}/'

def log(message):
    """Print timestamped log message."""
    print(f'[{datetime.now().isoformat()}] {message}', flush=True)

def health_check():
    """Perform a health check by hitting the health endpoint."""
    try:
        req = urllib.request.Request(HEALTH_URL)
        req.add_header('User-Agent', 'BlobeVM-Keepalive/1.0')
        with urllib.request.urlopen(req, timeout=5) as response:
            status = response.status
            if status == 200:
                log(f'✓ Health check passed (HTTP {status})')
                return True
            else:
                log(f'✗ Health check failed with status {status}')
                return False
    except urllib.error.URLError as e:
        log(f'✗ Health check error: {e.reason}')
        return False
    except urllib.error.HTTPError as e:
        log(f'✗ Health check HTTP error: {e.code} {e.reason}')
        return False
    except Exception as e:
        log(f'✗ Unexpected health check error: {e}')
        return False

def main():
    """Main keep-alive loop."""
    log(f'Starting keep-alive service')
    log(f'Target URL: {HEALTH_URL}')
    log(f'Check interval: {KEEP_ALIVE_INTERVAL}s')

    # Wait for the application to start
    log('Waiting 15 seconds for BlobeVM to initialize...')
    time.sleep(15)

    while True:
        try:
            log('Performing health check...')
            health_check()
            log(f'Next check in {KEEP_ALIVE_INTERVAL}s')
            time.sleep(KEEP_ALIVE_INTERVAL)
        except KeyboardInterrupt:
            log('Keep-alive service shutting down')
            sys.exit(0)
        except Exception as e:
            log(f'Unexpected error in keep-alive loop: {e}')
            log(f'Retrying in 30s...')
            time.sleep(30)

if __name__ == '__main__':
    main()
