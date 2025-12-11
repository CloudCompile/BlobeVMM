echo "**** Fixing broken dependencies ****"
apt-get update
apt-get --fix-broken install -y

echo "**** Installing OpenJDK 17 ****"
apt-get install -y --no-install-recommends openjdk-17-jdk wget unzip

echo "**** Downloading TLauncher ****"
wget -q -O /tmp/TLauncher.jar https://repo.tlauncher.org/update/lch/starter-core-1.11-v10.jar
mkdir -p /opt/tlauncher
mv /tmp/TLauncher.jar /opt/tlauncher/

cat > /usr/share/applications/tlauncher.desktop <<EOL
[Desktop Entry]
Name=TLauncher
Comment=Minecraft launcher
Exec=java -jar /opt/tlauncher/TLauncher.jar
Icon=/opt/tlauncher/TLauncher_icon.png
Terminal=false
Type=Application
Categories=Game;
EOL

wget -q -O /opt/tlauncher/TLauncher_icon.png https://cdn.icon-icons.com/icons2/2699/PNG/512/minecraft_logo_icon_168974.png

chmod +x /usr/share/applications/tlauncher.desktop

echo "**** TLauncher installation completed ****"
