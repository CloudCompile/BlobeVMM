#!/bin/bash
# KasmVNC Configuration for Optimized Performance

# This script sets up KasmVNC environment variables for better performance
# These settings optimize for speed, quality, and connection stability

# Performance optimizations
export KASMVNC_COMPRESSION_LEVEL=2  # Balance between quality and speed (0-9, lower = faster)
export KASMVNC_JPEG_QUALITY=7       # JPEG quality for framebuffer (0-9, higher = better quality)
export KASMVNC_WEBP_QUALITY=5       # WebP quality (0-9, balance for performance)

# Frame rate optimizations
export KASMVNC_MAX_FRAME_RATE=30    # Maximum frame rate (higher = smoother but more bandwidth)
export KASMVNC_IDLE_TIMEOUT=300     # Idle timeout in seconds

# Connection optimizations
export KASMVNC_DYNAMIC_QUALITY=true # Enable dynamic quality adjustment based on bandwidth

# Threading and performance
export KASMVNC_THREADS=4            # Number of threads for encoding (adjust based on CPU)

# Logging (set to false for production, true for debugging)
export KASMVNC_VERBOSE_LOGGING=false
