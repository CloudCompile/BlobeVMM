echo "**** install discord ****"
apt-get update
apt-get install -y --no-install-recommends libatomic1 wget
wget -q "https://discord.com/api/download?platform=linux&format=deb" -O /tmp/discord.deb
dpkg -i /tmp/discord.deb || apt-get install -f -y
rm /tmp/discord.deb