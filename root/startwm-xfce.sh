#!/bin/bash

# Disable screen blanking and power management
setterm blank 0
setterm powerdown 0

# Optimize XFCE performance by disabling compositing for remote desktop
if [ -f "${HOME}"/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml ]; then
  sed -i \
    '/use_compositing/c <property name="use_compositing" type="bool" value="false"/>' \
    "${HOME}"/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
fi

# Start XFCE session
/usr/bin/xfce4-session > /dev/null 2>&1