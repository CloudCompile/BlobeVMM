#!/bin/bash
# Optimized Lubuntu (LXQt) startup for maximum speed and VNC streaming performance
# Optimized for GitHub Codespace (2 core, 8GB RAM, 32GB storage)

echo "**** Starting optimized Lubuntu (LXQt) session for maximum speed ****"

# Disable screen blanking and power management for uninterrupted streaming
setterm blank 0
setterm powerdown 0

# Network/memory/CPU optimizations via sysctl (only possible when running as root)
if [ "$(id -u)" -eq 0 ] && [ -w /etc/sysctl.conf ]; then
  echo 'net.core.rmem_default = 262144' >> /etc/sysctl.conf
  echo 'net.core.rmem_max = 16777216' >> /etc/sysctl.conf
  echo 'net.core.wmem_default = 262144' >> /etc/sysctl.conf
  echo 'net.core.wmem_max = 16777216' >> /etc/sysctl.conf
  echo 'net.ipv4.tcp_rmem = 4096 65536 16777216' >> /etc/sysctl.conf
  echo 'net.ipv4.tcp_wmem = 4096 65536 16777216' >> /etc/sysctl.conf

  echo 'vm.swappiness = 10' >> /etc/sysctl.conf
  echo 'vm.vfs_cache_pressure = 50' >> /etc/sysctl.conf
  echo 'vm.dirty_ratio = 15' >> /etc/sysctl.conf
  echo 'vm.dirty_background_ratio = 5' >> /etc/sysctl.conf

  echo 'kernel.sched_migration_cost_ns = 5000000' >> /etc/sysctl.conf
  echo 'kernel.sched_autogroup_enabled = 0' >> /etc/sysctl.conf

  sysctl -p > /dev/null 2>&1 || true
else
  echo "(info) Skipping sysctl tuning (requires root)"
fi

# Set up PulseAudio for microphone support
setup_audio() {
    echo "**** Setting up audio system for microphone support ****"
    
    # Ensure PulseAudio can access audio devices
    if [ -d /dev/snd ]; then
        # Set permissions for audio devices
        chmod -R 666 /dev/snd/* 2>/dev/null || true
        chown -R pulse:pulse /dev/snd/* 2>/dev/null || true
    fi
    
    # Configure PulseAudio to run in system mode for container
    mkdir -p /var/run/pulse
    
    # Create PulseAudio configuration for Docker environment
    mkdir -p /root/.config/pulse
    cat > /root/.config/pulse/default.pa << 'EOF'
#!/usr/bin/pulseaudio -nF

# Fail if we don't have a working audio driver
.fail

# Load necessary modules
load-module module-device-restore
load-module module-stream-restore
load-module module-card-restore
load-module module-augment-properties
load-module module-switch-on-port-available

# Load the null sink for headless operation
load-module module-null-sink sink_name=blobevm_sink sink_properties=device.description="BlobeVM Audio Sink"

# Set the null sink as default
set-default-sink blobevm_sink
set-default-source blobevm_sink.monitor

# Enable network audio (optional for remote access)
load-module module-native-protocol-unix

# Load udev detection for audio devices
load-module module-udev-detect

# Set properties for better compatibility
load-module module-null-sink sink_name=blobevm_mic_sink sink_properties=device.description="BlobeVM Microphone"
EOF

    # Configure client.conf for PulseAudio
    cat > /root/.config/pulse/client.conf << 'EOF'
# Client configuration for BlobeVM
autospawn = yes
daemon-binary = /usr/bin/pulseaudio

# Enable TCP for network access
load-module module-tcp-sink
load-module module-tcp-source
EOF

    # Start PulseAudio if not already running
    if ! pgrep pulseaudio > /dev/null; then
        echo "Starting PulseAudio..."
        pulseaudio --start --log-target=syslog --exit-idle-time=-1 2>/dev/null || true
        sleep 2
    fi
    
    # Set PulseAudio to use the null sink by default
    export PULSE_SINK="blobevm_sink"
    export PULSE_SOURCE="blobevm_sink.monitor"
    
    echo "Audio system configured successfully"
}

# Run audio setup in background
setup_audio >/dev/null 2>&1 &

# Set environment variables for better performance and audio
export MOZ_DISABLE_ACCELERATED=2
export LIBGL_ALWAYS_INDIRECT=1
export QT_X11_NO_MITSHM=1
export _X11_NO_MITSHM=1
export _MITSHM=0

# Set audio environment variables
export PULSE_SERVER=unix:/run/user/$(id -u)/pulse/native
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# Create XDG_RUNTIME_DIR if it doesn't exist
mkdir -p /run/user/$(id -u)
chmod 700 /run/user/$(id -u)

echo "**** Starting Lubuntu (LXQt) (foreground) ****"
exec /usr/bin/startlxqt > /dev/null 2>&1