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
echo "Installing noVNC..."
mkdir -p $NO_VNC_DIR/utils/websockify
wget -qO- https://github.com/novnc/noVNC/archive/v0.6.2.tar.gz | tar xz --strip 1 -C $NO_VNC_DIR
# Use older version of websockify to prevent hanging connections on offline containers, see https://github.com/ConSol/docker-headless-vnc-container/issues/50
wget -qO- https://github.com/novnc/websockify/archive/v0.6.1.tar.gz | tar xz --strip 1 -C $NO_VNC_DIR/utils/websockify
chmod +x -v $NO_VNC_DIR/utils/*.sh
# Create index.html to forward automatically to `vnc_auto.html`
ln -s $NO_VNC_DIR/vnc_auto.html $NO_VNC_DIR/index.html