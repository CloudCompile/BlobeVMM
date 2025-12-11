#!/bin/bash

# Disable screen blanking and power management
setterm blank 0
setterm powerdown 0

# Start LXQT desktop session
/usr/bin/startlxqt > /dev/null 2>&1