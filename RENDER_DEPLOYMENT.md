# Deploying BlobeVM to Render

This guide explains how to deploy BlobeVM (Lubuntu desktop environment) to Render with a keep-alive mechanism to prevent the service from sleeping.

## Overview

BlobeVM is a containerized Lubuntu desktop that runs on port 3000 via VNC. When deployed to Render's free tier, services are suspended after periods of inactivity. This deployment includes:

- **Main Web Service**: The BlobeVM Lubuntu desktop accessible via VNC on port 3000
- **Keep-Alive Worker**: A background worker that periodically pings the service to prevent suspension
- **Health Check Endpoint**: A simple HTTP endpoint to verify the service is running

## Prerequisites

1. A [Render.com](https://render.com) account
2. This repository connected to your GitHub account
3. Minimum resource allocation (keep-alive worker runs on free tier)

## Setup Instructions

### Step 1: Connect Your Repository

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click "New" → "Web Service"
3. Select "Deploy an existing repository"
4. Connect your GitHub account and select the BlobeVMM repository

### Step 2: Configure the Web Service

When setting up the web service:

- **Name**: `blobevmm` (or your preferred name)
- **Environment**: Docker
- **Region**: Choose your preferred region (oregon, us-west, us-east, etc.)
- **Plan**: Standard (minimum recommended for decent VNC performance)
- **Build Command**: Leave empty (uses Dockerfile)
- **Start Command**: Leave empty (uses Dockerfile CMD)
- **Health Check Path**: `/` (KasmVNC responds to HTTP requests)
- **Health Check Interval**: 30 seconds
- **Health Check Timeout**: 10 seconds

### Step 3: Set Environment Variables

Add these environment variables:

```
PORT=3000
RENDER_DEPLOYMENT=true
```

### Step 4: Add Keep-Alive Worker (Optional but Recommended)

To prevent service suspension, add a background worker:

1. Click "Create Service" (from the Render dashboard) → Background Worker
2. Choose the same repository
3. Set these values:
   - **Name**: `keepalive-worker`
   - **Environment**: Python 3
   - **Build Command**: `pip install requests`
   - **Start Command**: `python3 keepalive.py`
   - **Plan**: Free (sufficient for keep-alive pings)

### Step 5: Deploy

1. The service will automatically deploy after pushing to your repository
2. Check the deployment logs to ensure everything starts correctly
3. Once deployed, access your BlobeVM at the provided Render URL

## How Keep-Alive Works

### Keep-Alive Worker

The `keepalive.py` script:
- Runs as a background worker service
- Pings the health endpoint every 5 minutes (configurable via `KEEP_ALIVE_INTERVAL`)
- Prevents the service from being suspended due to inactivity

### Health Check

- **Path**: `/health` or `/`
- **Frequency**: Every 30 seconds
- **Timeout**: 10 seconds
- The KasmVNC server responds to HTTP requests on port 3000

## Accessing Your BlobeVM

Once deployed:

1. Go to your Render deployment URL (e.g., `https://blobevmm.onrender.com`)
2. You'll see the KasmVNC login/desktop interface
3. Default credentials (if any):
   - Check the BlobeVM documentation or your custom setup

## Monitoring

### Check Service Status

1. Visit the Render Dashboard
2. Click on your `blobevmm` service
3. View logs to see health checks and any errors

### Keep-Alive Worker Status

1. Click on the `keepalive-worker` service
2. Check logs to verify it's pinging the main service every 5 minutes

## Troubleshooting

### Service Won't Start

1. Check build logs in Render dashboard
2. Ensure the Dockerfile is present and valid
3. Verify environment variables are set correctly

### Health Checks Failing

1. Check if the VNC server is responding:
   ```bash
   curl -v https://your-service.onrender.com/
   ```
2. Verify port 3000 is exposed in the Dockerfile
3. Check the container logs for startup errors

### Keep-Alive Worker Not Running

1. Verify the `keepalive.py` script exists in the repository root
2. Ensure `requests` package is installed
3. Check worker logs for Python errors

### VNC Performance Issues

- Upgrade to a higher-tier Render plan if experiencing slowness
- The keep-alive pings are lightweight and shouldn't impact performance

## Cost Considerations

- **Free Plan**: Services are suspended after 15 minutes of inactivity
- **Hobby Plan** ($7/month): Keeps services running continuously
- **Keep-Alive Strategy**: Using a keep-alive worker on the free plan keeps services active

## Advanced Configuration

### Customize Keep-Alive Interval

Edit `keepalive.py` and change:
```python
KEEP_ALIVE_INTERVAL = 300  # Change to desired seconds (minimum 60)
```

Then redeploy.

### Use Different Region

Edit `render.yaml` and change the `region` field:
- `oregon`
- `us-west`
- `us-east`
- `frankfurt`
- `singapore`

### Increase Health Check Sensitivity

Modify the health check settings in the Render dashboard:
- Decrease `healthCheckInterval` for more frequent checks
- Decrease `healthCheckTimeout` for faster failure detection (min 3s)

## Security Notes

- The VNC interface should ideally be protected with authentication
- Consider using a VPN or IP whitelist for production deployments
- Default Lubuntu credentials may be exposed in logs

## Further Reading

- [Render Docker Deployment Docs](https://render.com/docs/deploy-docker)
- [KasmVNC Documentation](https://github.com/kasmtech/KasmVNC)
- [BlobeVM GitHub](https://github.com/cloudcompile/BlobeVMM)

## Reverting to Render Dashboard Configuration

If you prefer to use the Render dashboard instead of `render.yaml`:

1. Delete `render.yaml` from the repository
2. Configure services manually in the Render dashboard
3. Ensure you still add the keep-alive worker for production use
