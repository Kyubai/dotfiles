#!/bin/bash

#TODO:
# install intel-ucode or amd-ucode

BASEDIR=$(dirname "$0")
export INSTALL_MODULES_DIR="$BASEDIR/install_modules"

if echo $@ | grep -qvE '(-u |--user )'; then
	echo 'usage: install.sh (--mode [guest|host]) --user username [--hacking-packages]'
	exit 1
fi

while [[ $1 ]]; do
	case "$1" in
	-h | --hacking-packages)
		export INSTALL_HACKING_PACKAGES=1
		shift
		;;
	-m | --mode)
		INSTALL_MODE=$2
		shift
		shift
		;;
	-u | --user)
		INSTALL_USER=$2
		shift
		shift
		;;
	esac
done

###############################################################
# detect package manager

[[ -f /usr/bin/apt ]] && INSTALLED_PACKAGE_MANAGER=apt
[[ -f /usr/sbin/pacman ]] && INSTALLED_PACKAGE_MANAGER=pacman

if [[ -z INSTALLED_PACKAGE_MANAGER ]]; then
	echo "package manager couldn't be detected"
	exit 1
fi

###############################################################
# setting execute permissions and running modules

echo "setting execute permissions on modules..."
chmod +x $INSTALL_MODULES_DIR/*.sh

echo "running install for $INSTALLED_PACKAGE_MANGER packages..."
$INSTALL_MODULES_DIR/$INSTALLED_PACKAGE_MANAGER.sh

if [[ -n $INSTALL_MODE ]]; then
	echo "running install of $INSTALL_MODE mode..."
	$INSTALL_MODULES_DIR/$INSTALL_MODE.sh
fi

###############################################################
# adjusting config and settings

echo "changing config and settings..."

# sudo xset s 10800
sudo timedatectl set-ntp true

sudo systemctl enable --now cronie

sudo chsh -s /bin/zsh $INSTALL_USER
sudo chsh -s /bin/zsh root

systemctl start --user pipewire-pulse
systemctl enable --user pipewire-pulse

###############################################################

echo "Done"

exit 0
