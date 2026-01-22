#!/bin/bash
set -euxo pipefail

# Create required directories
echo "Creating required directories..."
mkdir -p ~/.zcs-deps
mkdir -p ~/.ivy2/cache

# Environment variables
ENVIRONMENT_FILE="/etc/environment"
echo 'LANG=en_US.utf-8' >> $ENVIRONMENT_FILE
echo 'LANGUAGE='en_US:en'' >> $ENVIRONMENT_FILE

# Update the repository sources list
echo "Updating the repository sources list..."
apt-get -qq update -y
apt-get -qq install -y software-properties-common

# Purge snapd and prevent reinstallation
echo "Purging snapd..."
apt-get -qq purge -y snapd gnome-software-plugin-snap || true
rm -rf ~/snap /var/cache/snapd /usr/lib/snapd

# Block snapd
echo "Blocking snapd..."
cat > /etc/apt/preferences.d/nosnap.pref <<EOF
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

# Add Mozilla PPA for native Firefox
echo "Adding Mozilla PPA..."
add-apt-repository -y ppa:mozillateam/ppa
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' > /etc/apt/preferences.d/mozilla-firefox

# Update sources
echo "Updating the repository sources list..."
apt-get -qq autoremove -y
apt-get -qq update -y

# Install required packages
echo "Installing required packages..."
apt-get -qq install -y apt-utils \
	software-properties-common \
	build-essential \
	openssh-server \
	sudo \
	ant ant-optional ant-contrib \
	wget \
	iputils-ping \
	git \
	firefox \
	xdg-utils \
	libayatana-appindicator3-1 \
	fonts-liberation \
	libxss1 \
	vim \
	wget \
	net-tools \
	locales \
	bzip2 \
	python3-numpy \
	libnss-wrapper \
	gettext \
	dbus-x11

echo "Generating locales..."
locale-gen en_US.UTF-8

echo "Downloading ant contrib jar file..."
cd ~/.zcs-deps && wget https://files.zimbra.com/repository/ant-contrib/ant-contrib-1.0b1.jar

echo "Setting up ssh..."
# ssh-key setup and hack (when user changed for container)
#cat /dev/zero | ssh-keygen -C "itzkaguya@yukiprjkt.my.id" -q -N "" > /dev/null
#mkdir -p $HOME/.ssh && ssh-keyscan github.com >> $HOME/.ssh/known_hosts

echo "Setting up timezone..."
echo "alias ll='ls -alF'" >> $HOME/.bashrc
ln -sf /usr/share/zoneinfo/Asia/Makassar /etc/localtime
