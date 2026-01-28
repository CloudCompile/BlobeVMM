#!/bin/bash
# Optimized XFCE4 startup for maximum speed and VNC streaming performance
# Optimized for GitHub Codespace (2 core, 8GB RAM, 32GB storage)

echo "**** Starting optimized XFCE4 session for maximum speed ****"

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

# Optimize XFCE performance by disabling compositing for remote desktop
if [ -f "${HOME}"/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml ]; then
  sed -i \
    '/use_compositing/c <property name="use_compositing" type="bool" value="false"/>' \
    "${HOME}"/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
fi

# Disable unnecessary XFCE4 services for speed
export GNOME_DISABLE_USER_CONFIG=1
export OXYGEN_DISABLE_KDE4=1

# Set environment variables for better performance
export MOZ_DISABLE_ACCELERATED=2
export LIBGL_ALWAYS_INDIRECT=1
export QT_X11_NO_MITSHM=1
export _X11_NO_MITSHM=1
export _MITSHM=0

# Start XFCE session with optimizations
/usr/bin/startxfce4 > /dev/null 2>&1 &

# Wait a moment for XFCE to start
sleep 2

# Additional performance optimizations after startup
if [ -f "${HOME}"/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml ]; then
  # Disable window shadows for faster streaming
  sed -i \
    '/show_dock_shadow/c <property name="show_dock_shadow" type="bool" value="false"/>' \
    "${HOME}"/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
  
  # Disable tooltips for faster interaction
  sed -i \
    '/show_tooltips/c <property name="show_tooltips" type="bool" value="false"/>' \
    "${HOME}"/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
  
  # Disable workspace wrapping for better performance
  sed -i \
    '/wrap_workspaces/c <property name="wrap_workspaces" type="bool" value="false"/>' \
    "${HOME}"/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
fi

# Disable desktop icons for faster startup and streaming
if [ -f "${HOME}"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml ]; then
  sed -i \
    '/show-home/c <property name="show-home" type="bool" value="false"/>' \
    "${HOME}"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
  sed -i \
    '/show-filesystem/c <property name="show-filesystem" type="bool" value="false"/>' \
    "${HOME}"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
  sed -i \
    '/show-removable/c <property name="show-removable" type="bool" value="false"/>' \
    "${HOME}"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
fi

echo "**** Optimized XFCE4 session started successfully ****"