#!/bin/bash

# Optimize KDE performance for remote desktop
if [ ! -f $HOME/.config/kwinrc ]; then
  # Disable compositing for better performance in remote desktop
  kwriteconfig5 --file $HOME/.config/kwinrc --group Compositing --key Enabled false
  # Disable effects for better performance
  kwriteconfig5 --file $HOME/.config/kwinrc --group Compositing --key GLCore true
  kwriteconfig5 --file $HOME/.config/kwinrc --group Compositing --key Backend OpenGL
fi

if [ ! -f $HOME/.config/kscreenlockerrc ]; then
  # Disable screen locking
  kwriteconfig5 --file $HOME/.config/kscreenlockerrc --group Daemon --key Autolock false
fi

# Disable screen blanking and power management
setterm blank 0
setterm powerdown 0

# Start KDE Plasma
/usr/bin/dbus-launch /usr/bin/startplasma-x11 > /dev/null 2>&1
