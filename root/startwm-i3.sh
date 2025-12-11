#!/bin/bash

# Disable screen blanking and power management
setterm blank 0
setterm powerdown 0

# Start i3 window manager (lightweight, no compositing needed)
/usr/bin/i3 > /dev/null 2>&1