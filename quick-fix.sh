#!/bin/bash
# Quick Fix Script for GitHub Codespace Docker Issues
# This fixes the specific errors you encountered

echo "🔧 Quick Fix for GitHub Codespace Docker Issues"
echo "================================================"

# Fix 1: Clean up existing directory
echo "🧹 Cleaning up existing BlobeVMM directory..."
if [ -d "BlobeVMM" ]; then
    sudo rm -rf BlobeVMM
    echo "✅ Cleaned up BlobeVMM directory"
else
    echo "✅ No existing directory found"
fi

# Fix 2: Check Docker version and method
echo "🐳 Checking Docker setup..."
if docker buildx version >/dev/null 2>&1; then
    echo "✅ Docker buildx detected (GitHub Codespace)"
    DOCKER_CMD="docker buildx build"
    DOCKER_METHOD="buildx"
else
    echo "✅ Regular Docker detected"
    DOCKER_CMD="docker build"
    DOCKER_METHOD="regular"
fi

# Fix 3: Ensure we're in the right directory
if [ ! -f "Dockerfile" ]; then
    echo "❌ Dockerfile not found in current directory"
    echo "💡 Make sure you're in the BlobeVMM directory"
    exit 1
fi

# Fix 4: Build with correct method
echo "🔨 Building Docker image with correct method..."
echo "   Using: $DOCKER_CMD"

if [ "$DOCKER_METHOD" = "buildx" ]; then
    echo "   ✅ Using Docker buildx (compatible flags only)"
    DOCKER_BUILDKIT=1 $DOCKER_CMD --progress=plain --no-cache --load -t blobevm-optimized .
else
    echo "   ✅ Using regular Docker build"
    DOCKER_BUILDKIT=1 $DOCKER_CMD --progress=plain --no-cache -t blobevm-optimized .
fi

BUILD_EXIT_CODE=$?

# Fix 5: Check if build was successful
if [ $BUILD_EXIT_CODE -eq 0 ]; then
    echo "✅ Docker image built successfully!"

    # Verify image exists locally before trying to run it
    if ! docker image inspect blobevm-optimized:latest >/dev/null 2>&1 && ! docker image inspect blobevm-optimized >/dev/null 2>&1; then
        echo "❌ Build reported success, but image 'blobevm-optimized' was not found locally"
        echo "💡 Try rebuilding, or check for build errors above"
        exit 1
    fi

    # Fix 6: Start container with correct flags
    echo "🚀 Starting container..."

    # Recreate the container if it already exists
    if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -qx "BlobeVM-Optimized"; then
        docker rm -f BlobeVM-Optimized >/dev/null 2>&1 || true
    fi

    # Avoid accidental registry pulls when the local image is missing
    PULL_NEVER=""
    if docker run --help 2>/dev/null | grep -q -- '--pull'; then
        PULL_NEVER="--pull=never"
    fi

    docker run $PULL_NEVER -d \
      --name=BlobeVM-Optimized \
      -e PUID=1000 \
      -e PGID=1000 \
      --device=/dev/kvm \
      --security-opt seccomp=unconfined \
      -e TZ=Etc/UTC \
      -e SUBFOLDER=/ \
      -e TITLE="BlobeVM XFCE4 Optimized" \
      -p 3000:3000 \
      --shm-size=2g \
      -v "$(pwd)/Save:/config" \
      --restart unless-stopped \
      blobevm-optimized
    
    if [ $? -eq 0 ]; then
        echo "⏳ Waiting for web UI on port 3000..."

        READY=0
        for i in {1..90}; do
            if curl -fsS --max-time 2 http://localhost:3000 >/dev/null 2>&1 || curl -fkSs --max-time 2 https://localhost:3000 >/dev/null 2>&1; then
                READY=1
                break
            fi
            if ! docker ps --format '{{.Names}}' 2>/dev/null | grep -qx "BlobeVM-Optimized"; then
                echo "❌ Container exited during startup"
                docker logs --tail 200 BlobeVM-Optimized || true
                exit 1
            fi
            sleep 2
        done

        if [ $READY -ne 1 ]; then
            echo "❌ Web UI is not responding on port 3000"
            docker ps -a --filter name=BlobeVM-Optimized || true
            docker logs --tail 200 BlobeVM-Optimized || true
            exit 1
        fi

        echo ""
        echo "🎉 SUCCESS! BlobeVM is now running!"
        echo ""
        echo "📊 What was fixed:"
        echo "   ✅ Cleaned up existing directory"
        echo "   ✅ Detected Docker build method: $DOCKER_METHOD"
        echo "   ✅ Used correct Docker build flags"
        echo "   ✅ Started container successfully"
        echo ""
        echo "🌐 Access at: http://localhost:3000 (try https://localhost:3000 if your environment forces HTTPS)"
        echo "⏱️  Wait 30-60 seconds for full startup"
    else
        echo "❌ Container start failed"
        echo "💡 Check logs: docker logs BlobeVM-Optimized"
    fi
else
    echo "❌ Docker build failed (exit code: $BUILD_EXIT_CODE)"
    echo "💡 This might be due to:"
    echo "   - Network issues during package download"
    echo "   - Insufficient disk space"
    echo "   - Memory constraints"
    echo ""
    echo "💡 Try manual build:"
    echo "   DOCKER_BUILDKIT=1 docker build --no-cache -t blobevm-optimized ."
    echo ""
    echo "💡 Or check system resources:"
    echo "   docker system df"
    echo "   free -h"
fi