echo "**** install steam ****"
apt-get update
apt-get install -y libgl1-mesa-dri:i386 libgl1:i386
wget "https://steamcdn-a.akamaihd.net/client/installer/steam.deb" -O /tmp/steam.deb
dpkg -i /tmp/steam.deb || apt-get install -f -y
sleep 1
rm /tmp/steam.deb
