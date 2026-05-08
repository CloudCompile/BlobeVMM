#!/usr/bin/env python3
"""
Simple HTTP health check endpoint for BlobeVM on Render.
Responds on port 5000 to indicate the service is alive.
"""

import http.server
import socketserver
import os
import subprocess
import threading
import time
from datetime import datetime

PORT = 5000
VNC_PORT = 3000
CHECK_INTERVAL = 30

def log(message):
    """Print timestamped log message."""
    print(f'[{datetime.now().isoformat()}] {message}', flush=True)

def check_vnc_health():
    """Check if VNC server is responding."""
    try:
        result = subprocess.run(
            ['curl', '-sf', '--max-time', '5', f'http://localhost:{VNC_PORT}/'],
            capture_output=True,
            timeout=10
        )
        return result.returncode == 0
    except Exception as e:
        log(f'VNC health check failed: {e}')
        return False

def health_check_thread():
    """Background thread to periodically check VNC health."""
    vnc_healthy = True
    while True:
        try:
            current_health = check_vnc_health()
            if current_health != vnc_healthy:
                status = "✓" if current_health else "✗"
                log(f'{status} VNC server health check: {current_health}')
                vnc_healthy = current_health
        except Exception as e:
            log(f'Unexpected error in health check thread: {e}')

        time.sleep(CHECK_INTERVAL)

class HealthCheckHandler(http.server.SimpleHTTPRequestHandler):
    """HTTP request handler for health checks."""

    def do_GET(self):
        """Handle GET requests."""
        if self.path == '/health' or self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'OK\n')
            log(f'Health check request from {self.client_address[0]}')
        else:
            self.send_response(404)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'Not Found\n')

    def log_message(self, format, *args):
        """Suppress default logging."""
        pass

def run_health_check_server():
    """Run the health check HTTP server."""
    with socketserver.TCPServer(("0.0.0.0", PORT), HealthCheckHandler) as httpd:
        log(f'Health check server listening on port {PORT}')
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            log('Health check server shutting down')

if __name__ == '__main__':
    # Start background health check thread
    check_thread = threading.Thread(target=health_check_thread, daemon=True)
    check_thread.start()
    log(f'Started health check endpoint on port {PORT}')

    # Run the HTTP server
    run_health_check_server()
