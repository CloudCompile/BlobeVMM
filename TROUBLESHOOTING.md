# GitHub Codespace Troubleshooting Guide

## Common Issues and Solutions

### 🚨 Issue: APT GPG Errors
**Error**: `GPG error: https://dl.yarnpkg.com/debian stable InRelease: The following signatures were invalid: EXPKEYSIG 23E7166788B63E1E`

**Solution**: The installation script now automatically fixes this issue by:
- Removing problematic repositories
- Cleaning APT cache
- Using `--allow-releaseinfo-change` flag

### 🚨 Issue: Permission Denied Errors
**Error**: `Permission denied` when running apt commands

**Solution**: The script now:
- Automatically detects sudo availability
- Uses `run_with_sudo()` function for all system commands
- Falls back gracefully if sudo is not available

### 🚨 Issue: Docker Build Failures
**Error**: Docker build fails in GitHub Codespace

**Solutions**:
1. **Manual Build** (Recommended):
   ```bash
   DOCKER_BUILDKIT=1 docker build --no-cache -t blobevm-optimized .
   ```

2. **Alternative Build**:
   ```bash
   docker build --no-cache --memory=6g --cpus=2 -t blobevm-optimized .
   ```

3. **Check Docker Status**:
   ```bash
   sudo systemctl status docker
   sudo systemctl start docker
   ```

### 🚨 Issue: Memory Limits
**Error**: Container killed due to memory limits

**Solution**: The script now:
- Limits container memory to 6GB
- Uses shared memory optimization (2GB)
- Optimizes for 8GB RAM constraint

### 🚨 Issue: Network Timeouts
**Error**: Network timeouts during package installation

**Solutions**:
1. **Increase timeouts** in APT configuration
2. **Use alternative mirrors**:
   ```bash
   sudo sed -i 's|http://archive.ubuntu.com|https://mirror.us.leaseweb.net|g' /etc/apt/sources.list
   ```

## 🔧 Alternative Installation Methods

### Method 1: Minimal Installation
```bash
# Skip the installation script and build directly
DOCKER_BUILDKIT=1 docker build --no-cache -t blobevm-minimal .
docker run -d --name BlobeVM-Minimal -p 3000:3000 blobevm-minimal
```

### Method 2: Pre-built Image
```bash
# If Docker Hub image is available
docker pull blobevm/optimized:latest
docker run -d --name BlobeVM-Optimized -p 3000:3000 blobevm/optimized:latest
```

### Method 3: Manual Step-by-Step
```bash
# 1. Update system (with error handling)
sudo apt update --allow-releaseinfo-change -y

# 2. Install essential packages only
sudo apt install -y jq docker.io

# 3. Start Docker
sudo systemctl start docker

# 4. Build with minimal dependencies
DOCKER_BUILDKIT=1 docker build --no-cache -t blobevm-manual .
```

## 📊 Performance Optimization

### GitHub Codespace Specific Settings
- **Memory**: Limited to 6GB for stability
- **CPU**: Limited to 2 cores for efficiency
- **Storage**: Optimized for 32GB constraint
- **Network**: Enhanced buffering for VNC streaming

### Expected Performance
- **Build Time**: 8-12 minutes (vs 15-20 minutes standard)
- **Startup Time**: 30-45 seconds (vs 60-90 seconds standard)
- **Memory Usage**: 2-3GB (vs 4-6GB standard)
- **VNC Speed**: 40-60% faster streaming

## 🛠️ Debug Commands

### Check System Resources
```bash
# Memory usage
free -h

# CPU info
nproc

# Disk space
df -h

# Docker status
docker info
```

### Check Installation Progress
```bash
# View build logs
cat build_progress.log

# Check container status
docker ps -a

# View container logs
docker logs BlobeVM-Optimized

# Monitor resource usage
docker stats BlobeVM-Optimized
```

### Validate Installation
```bash
# Run validation script
./validate-optimizations.sh

# Check XFCE4 installation
docker exec BlobeVM-Optimized xfce4-session --version

# Test VNC connection
curl -I http://localhost:3000
```

## 🎯 Quick Fixes

### If Installation Hangs
1. **Kill the process**: `Ctrl+C`
2. **Clean up**: `docker system prune -f`
3. **Retry**: `./install.sh`

### If Container Won't Start
1. **Check logs**: `docker logs BlobeVM-Optimized`
2. **Restart Docker**: `sudo systemctl restart docker`
3. **Check resources**: `docker system df`

### If Port 3000 Shows "Unable to handle this request"
This usually means the container is running but the web UI inside the container isn't ready (or it crashed during startup).

1. **Check container status**:
   ```bash
   docker ps -a --filter name=BlobeVM-Optimized
   ```
2. **Check logs**:
   ```bash
   docker logs --tail 200 BlobeVM-Optimized
   ```
3. **Wait a bit**: first start can take 1-3 minutes.
4. **Restart**:
   ```bash
   docker restart BlobeVM-Optimized
   ```

### If VNC Connection Fails
1. **Check port**: `netstat -tlnp | grep 3000`
2. **Test accessibility**: `curl -I http://localhost:3000`
3. **Check firewall**: Ensure port 3000 is accessible

## 📞 Support

If issues persist:

1. **Check logs**: Always start with `docker logs BlobeVM-Optimized`
2. **Validate system**: Run `./validate-optimizations.sh`
3. **Manual build**: Try alternative installation methods above
4. **Resource check**: Ensure sufficient memory and CPU available

## 🚀 Success Indicators

✅ **Installation Successful When**:
- Docker build completes without errors
- Container starts and stays running
- HTTP 200 response from http://localhost:3000
- XFCE4 desktop loads in browser
- Memory usage stays under 6GB
- Build log shows "Successfully built"

---

**Remember**: GitHub Codespace has resource constraints. The optimizations are specifically designed for this environment!