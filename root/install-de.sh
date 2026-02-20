#!/bin/bash
# Optimized Lubuntu (LXQt)-only installation for maximum speed
# No conditionals needed - only Lubuntu installation

echo "**** Installing optimized Lubuntu (LXQt) for maximum performance ****"

# Single apt update for the entire build
apt-get update

# Install Lubuntu (LXQt) with optimized package selection for speed
DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    # LXQt Core - lightweight and fast
    lxqt \
    lubuntu-default-settings \
    qterminal \
    featherpad

# Remove unnecessary autostart items for speed
rm -f /etc/xdg/autostart/xscreensaver.desktop \
       /etc/xdg/autostart/pulseaudio.desktop \
       /etc/xdg/autostart/blueberry-autostart.desktop \
       /etc/xdg/autostart/gnome-keyring-pkcs11.desktop \
       /etc/xdg/autostart/gnome-keyring-secrets.desktop \
       /etc/xdg/autostart/gnome-keyring-ssh.desktop \
       /etc/xdg/autostart/gsettings-desktop-schemas.desktop \
       /etc/xdg/autostart/pulseaudio.desktop \
       /etc/xdg/autostart/rfkill-unblock.desktop \
       /etc/xdg/autostart/spice-vdagent.desktop \
       /etc/xdg/autostart/thunar-volman.desktop

# Set Lubuntu (LXQt) as the default window manager
cp /startwm-lxqt.sh /defaults/startwm.sh
chmod +x /defaults/startwm.sh

# Clean up all other desktop environment scripts
rm -f /startwm-kde.sh /startwm-i3.sh /startwm-xfce.sh /startwm-gnome.sh /startwm-cinnamon.sh

echo "**** Lubuntu (LXQt) installation completed ****"