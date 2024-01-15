#!/bin/bash

#TODO:
# install intel-ucode or amd-ucode
export USER=mri

if echo $@ | grep -qvE '(-m |--mode )'; then
	echo 'usage: install.sh --mode [guest|host|none] [--security]'
	exit 1
fi

while [[ $1 ]]; do
	case "$1" in
		-s | --security)
			export INSTALL_SECURITY=1
			shift
			;;
		-m | --mode)
			mode=$2
			echo "mode is: $mode"
			shift
			shift
			;;
	esac
done

BASEDIR=$(dirname "$0")
export module_dir="$BASEDIR/install_modules"

# pacman_vboxhost="virtualbox virtualbox-host-dkms i3lock flameshot arandr
# realtime-privileges gnome-keyring cronie"
pacman_security="responder cdrkit qemu-headless nbd pwndrop crackmapexec impacket bloodhound metasploit hashcat seclists burpsuite chisel nmap recon-ng wpscan libpff dc3dd dislocker john ghidra radare2 squashfs-tools libewf chntpw hydra"
pacman_essentials="net-tools base-devel vim linux-lts-headers man-db dhcpcd dhclient ttf-font openssh zsh yay networkmanager nm-connection-editor openvpn wireless_tools iw crda linux-firmware python python-pip unzip xorg xorg-xinit xterm i3-gaps dmenu i3status nitrogen volumeicon network-manager-applet keepassxc ffmpeg zip unzip ethtool proxychains nautilus tcpdump ranger feh xfce4-power-manager htop alsa-utils pavucontrol dnsmasq darkhttpd libbde wireshark-qt tmux ntfs-3g xfce4-terminal lsof sshfs git ttf-liberation dnsutils python2-virtualenv syncthing rust neovim firefox chromium code adobe-source-code-pro-fonts yay pipewire wireplumber pipewire-alsa vlc jq gron rust-src qemu pv p7zip sway xdg-desktop-portal xdg-desktop-portal-wlr grim slurp wl-clipboard libvshadow swaylock wtype python-virtualenv csvkit pipewire-jack fuzzel libnotify ffmpeg bolt filezilla qemu xpdf neofetch netcat swaybg mako mercurial meson xfce4-terminal noto-fonts wqy-microhei wqy-zenhei nfs-utils zellij yadm starship exa ttf-hack-nerd choose bat zoxide kitty"
pacman_optionals="discord"
yay_essentials="wl-mirror liblnk-tools-git wdisplays libcaption-git obs-replay-source brave-bin gdk-pixbuf gruvbox-dark-gtk gruvbox-dark-icons-gtk dua"

###############################################################

echo 'installing pacman upgrades'

sudo pacman -Syu --noconfirm

###############################################################

for package in $pacman_vboxhost $pacman_essentials $pacman_optionals; do
    sudo pacman -S $package --needed --noconfirm 2>&1 | grep -iv ' skipping$\|there is nothing to do'
done

###############################################################

if ! [ -z $INSTALL_SECURITY ]; then
	echo 'installing security packages...'
	cat /etc/pacman.conf | grep -i 'blackarch'
	if [ $? -ne 0 ]; then
		echo 'installing blackarch repository'
		sudo mkdir -p /root/Downloads
		sudo curl -O https://blackarch.org/strap.sh --output-dir /root/Downloads
		sudo chmod +x /root/Downloads/strap.sh
		sudo /root/Downloads/strap.sh
	fi
	for package in $pacman_security; do
            sudo pacman -S $package --needed 2>&1 | grep -iv ' skipping$\|there is nothing to do'
        done
fi

###############################################################

# sudo xset s 10800
sudo timedatectl set-ntp true

###############################################################

echo "starting executing of mode: $mode"

chmod +x $module_dir/*.sh

if [ $mode = "guest" ]; then
	echo 'starting installation of guest packages'
	$module_dir/guest.sh;
fi
if [ $mode = "host" ]; then
    echo 'starting installation of host packages'

    sudo chsh -s /bin/zsh $USER
    sudo chsh -s /bin/zsh root
    sudo systemctl enable --now cronie
    systemctl start --user pipewire-pulse
    systemctl enable --user pipewire-pulse
    echo consider doing sudo systemctl enable mount-shared-folder-addyet

    for package in $pacman_vboxhost; do
        sudo pacman -S $package --needed 2>&1 | grep -iv ' skipping$\|there is nothing to do'
    done
    $module_dir/host.sh
fi

###############################################################

echo "Done"
