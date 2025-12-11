#!/bin/bash

# Disable screen blanking and power management
setterm blank 0
setterm powerdown 0

# Set GNOME environment variables
export XDG_CURRENT_DESKTOP=GNOME
export XDG_SESSION_TYPE=x11

# Start DBus service
sudo service dbus start

# Start GNOME Shell in X11 mode with replace flag
/usr/bin/gnome-shell --x11 -r > /dev/null 2>&1