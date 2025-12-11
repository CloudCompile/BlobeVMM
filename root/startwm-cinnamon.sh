#!/bin/bash

# Disable screen blanking and power management
setterm blank 0
setterm powerdown 0

# Start Cinnamon desktop session
/usr/bin/cinnamon-session > /dev/null 2>&1