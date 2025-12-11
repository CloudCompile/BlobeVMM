echo "**** install wine ****"
dpkg --add-architecture i386
mkdir -pm755 /etc/apt/keyrings
wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
apt-get update
# Install winehq-staging which includes wine and all dependencies
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends wget winehq-staging
