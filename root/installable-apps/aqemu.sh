echo "**** install aqemu ****"
apt-get update
apt-get install -y --no-install-recommends aqemu
rm -f /usr/share/applications/aqemu.desktop
cp /installable-apps/aqemu.desktop /usr/share/applications/aqemu.desktop