#!/bin/bash
set -e  # Exit on error

json_file="/options.json"

echo "**** Starting application installations ****"

# Make all scripts executable at once
chmod +x /installable-apps/*.sh

# Install default apps
if jq ".defaultapps | contains([0])" "$json_file" | grep -q true; then
    echo "Installing Wine..."
    /installable-apps/wine.sh
fi
if jq ".defaultapps | contains([1])" "$json_file" | grep -q true; then
    echo "Installing Chrome..."
    /installable-apps/chrome.sh
fi
if jq ".defaultapps | contains([2])" "$json_file" | grep -q true; then
    echo "Installing Xarchiver..."
    /installable-apps/xarchiver.sh
fi
if jq ".defaultapps | contains([3])" "$json_file" | grep -q true; then
    echo "Installing Discord..."
    /installable-apps/discord.sh
fi
if jq ".defaultapps | contains([4])" "$json_file" | grep -q true; then
    echo "Installing Steam..."
    /installable-apps/steam.sh
fi
if jq ".defaultapps | contains([5])" "$json_file" | grep -q true; then
    echo "Installing Minecraft..."
    /installable-apps/minecraft.sh
fi

# Install programming tools
if jq ".programming | contains([0])" "$json_file" | grep -q true; then
    echo "Installing OpenJDK 8 JRE..."
    /installable-apps/openjdk-8-jre.sh
fi
if jq ".programming | contains([1])" "$json_file" | grep -q true; then
    echo "Installing OpenJDK 17 JRE..."
    /installable-apps/openjdk-17-jre.sh
fi
if jq ".programming | contains([2])" "$json_file" | grep -q true; then
    echo "Installing VSCodium..."
    /installable-apps/vscodium.sh
fi

# Install additional apps
if jq ".apps | contains([0])" "$json_file" | grep -q true; then
    echo "Installing VLC..."
    /installable-apps/vlc.sh
fi
if jq ".apps | contains([1])" "$json_file" | grep -q true; then
    echo "Installing LibreOffice..."
    /installable-apps/libreoffice.sh
fi
if jq ".apps | contains([2])" "$json_file" | grep -q true; then
    echo "Installing Synaptic..."
    /installable-apps/synaptic.sh
fi
if jq ".apps | contains([3])" "$json_file" | grep -q true; then
    echo "Installing AQemu..."
    /installable-apps/aqemu.sh
fi
if jq ".apps | contains([4])" "$json_file" | grep -q true; then
    echo "Installing TLauncher..."
    /installable-apps/tlauncher.sh
fi

# Clean up
echo "**** Cleaning up installation files ****"
rm -rf /installable-apps

echo "**** Application installations completed ****"
