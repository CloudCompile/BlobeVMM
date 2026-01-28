#!/bin/bash
# Optimized XFCE4-only installation for maximum speed
# No conditionals needed - only XFCE4 installation

echo "**** Installing optimized XFCE4 for maximum performance ****"

# Single apt update for the entire build
apt-get update

# Install XFCE4 with optimized package selection for speed
DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    # XFCE4 Core - lightweight and fast
    xfce4 \
    xubuntu-default-settings \
    xubuntu-icon-theme \
    xfce4-terminal \
    mousepad

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
       /etc/xdg/autostart/thunar-volman.desktop \
       /etc/xdg/autostart/xfce4-clipman-plugin-autostart.desktop \
       /etc/xdg/autostart/xfce4-power-manager.desktop \
       /etc/xdg/autostart/xfce4-settings-daemon.desktop \
       /etc/xdg/autostart/xfce4-session-autostart.desktop \
       /etc/xdg/autostart/xfce4-xkb-plugin-autostart.desktop

# Set XFCE4 as the default window manager
cp /startwm-xfce.sh /defaults/startwm.sh
chmod +x /defaults/startwm.sh

# Clean up all other desktop environment scripts
rm -f /startwm-kde.sh /startwm-i3.sh /startwm-xfce.sh /startwm-gnome.sh /startwm-cinnamon.sh /startwm-lxqt.sh

echo "**** XFCE4 installation completed ****"