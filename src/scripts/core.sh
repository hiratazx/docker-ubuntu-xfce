#!/bin/bash
set -euxo pipefail

# Xfce UI
echo "Installing Xfce4 UI components"
apt-get -qq install -y supervisor xfce4 xfce4-terminal
apt-get -qq purge -y pm-utils xscreensaver*

# Java
echo "Installing Java..."
echo "===> Install Java8"  && \
apt-get -qq install -y openjdk-8-jdk && \
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Chrome browser
echo "Installing chrome browser..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
dpkg -i google-chrome-stable_current_amd64.deb; apt-get -y install && \
rm google-chrome-stable_current_amd64.deb
#sed -i -e 's@Exec=/usr/bin/google-chrome-stable %U@Exec=/usr/bin/google-chrome-stable %U --no-sandbox@g' /usr/share/applications/google-chrome.desktop && \
#ln -s /usr/share/applications/google-chrome.desktop ~/Desktop && \
#chmod +x ~/Desktop/google-chrome.desktop

# TigerVNC
echo "Installing TigerVNC server..."
sudo apt-get -qq install -y tigervnc-standalone-server tigervnc-common

# noVNC
# noVNC
echo "Installing noVNC..."
apt-get -qq install -y novnc websockify python3-numpy
# Create index.html to forward automatically to `vnc_lite.html`
ln -s /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html