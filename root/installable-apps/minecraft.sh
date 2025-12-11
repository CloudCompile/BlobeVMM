echo "**** install minecraft ****"
apt-get update
apt-get install -y --no-install-recommends default-jre wget
wget -q https://launcher.mojang.com/download/Minecraft.deb -O /tmp/Minecraft.deb
dpkg -i /tmp/Minecraft.deb || apt-get install -f -y
rm /tmp/Minecraft.deb
