#!/bin/bash
set -e  # Exit on error

echo "Cloning BlobeVM repository..."
git clone https://github.com/Blobby-Boi/BlobeVM
cd BlobeVM

echo "Installing Python dependencies..."
pip install textual

sleep 2
python3 installer.py

echo "Building Docker image with BuildKit..."
DOCKER_BUILDKIT=1 docker build -t blobevm . --no-cache

cd ..

echo "Updating system and installing dependencies..."
sudo apt update
sudo apt install -y jq

echo "Setting up configuration directory..."
mkdir -p Save
cp -r BlobeVM/root/config/* Save

json_file="BlobeVM/options.json"
echo "Starting BlobeVM container..."
if jq ".enablekvm" "$json_file" | grep -q true; then
    docker run -d \
      --name=BlobeVM \
      -e PUID=1000 \
      -e PGID=1000 \
      --device=/dev/kvm \
      --security-opt seccomp=unconfined \
      -e TZ=Etc/UTC \
      -e SUBFOLDER=/ \
      -e TITLE=BlobeVM \
      -p 3000:3000 \
      --shm-size="4gb" \
      -v $(pwd)/Save:/config \
      --restart unless-stopped \
      blobevm
else
    docker run -d \
      --name=BlobeVM \
      -e PUID=1000 \
      -e PGID=1000 \
      --security-opt seccomp=unconfined \
      -e TZ=Etc/UTC \
      -e SUBFOLDER=/ \
      -e TITLE=BlobeVM \
      -p 3000:3000 \
      --shm-size="4gb" \
      -v $(pwd)/Save:/config \
      --restart unless-stopped \
      blobevm
fi

clear
echo "BLOBEVM WAS INSTALLED SUCCESSFULLY! Check Port Tab"
