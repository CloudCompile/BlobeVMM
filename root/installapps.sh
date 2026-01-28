#!/bin/bash
set -e  # Exit on error

json_file="/options.json"

echo "**** Starting application installations ****"

# Make all scripts executable at once
chmod +x /installable-apps/*.sh

has_selection() {
    local field="$1"
    local id="$2"
    jq -e --argjson id "$id" "($field // []) | index($id) != null" "$json_file" >/dev/null 2>&1
}

# Check both defaultapps and apps for each installation
# Wine (can be in defaultapps[3] or apps[0])
if has_selection '.defaultapps' 3 || has_selection '.apps' 0; then
    echo "Installing Wine..."
    /installable-apps/wine.sh
fi
# Chrome (defaultapps[4])
if has_selection '.defaultapps' 4; then
    echo "Installing Chrome..."
    /installable-apps/chrome.sh
fi
# VLC (apps[1])
if has_selection '.apps' 1; then
    echo "Installing VLC..."
    /installable-apps/vlc.sh
fi
# LibreOffice (apps[2])
if has_selection '.apps' 2; then
    echo "Installing LibreOffice..."
    /installable-apps/libreoffice.sh
fi
# Discord (apps[3])
if has_selection '.apps' 3; then
    echo "Installing Discord..."
    /installable-apps/discord.sh
fi
# Steam (apps[4])
if has_selection '.apps' 4; then
    echo "Installing Steam..."
    /installable-apps/steam.sh
fi
# Minecraft (apps[5])
if has_selection '.apps' 5; then
    echo "Installing Minecraft..."
    /installable-apps/minecraft.sh
fi
# VSCodium (apps[6])
if has_selection '.apps' 6; then
    echo "Installing VSCodium..."
    /installable-apps/vscodium.sh
fi
# Synaptic (can be in defaultapps[5] or apps[7])
if has_selection '.defaultapps' 5 || has_selection '.apps' 7; then
    echo "Installing Synaptic..."
    /installable-apps/synaptic.sh
fi
# AQemu (apps[8])
if has_selection '.apps' 8; then
    echo "Installing AQemu..."
    /installable-apps/aqemu.sh
fi
# TLauncher (apps[9])
if has_selection '.apps' 9; then
    echo "Installing TLauncher..."
    /installable-apps/tlauncher.sh
fi

echo "**** Cleaning up installation files ****"
rm -rf /installable-apps

echo "**** Application installations completed ****"
