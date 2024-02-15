#!/bin/bash

# pacman_vboxhost="virtualbox virtualbox-host-dkms i3lock flameshot arandr
# realtime-privileges gnome-keyring cronie"
PACMAN_HACKING_PACKAGES="responder cdrkit qemu-headless nbd pwndrop crackmapexec impacket bloodhound metasploit hashcat seclists burpsuite chisel nmap recon-ng wpscan libpff dc3dd dislocker john ghidra radare2 squashfs-tools libewf chntpw hydra"
PACMAN_ESSENTIAL_PACKAGES="net-tools base-devel vim linux-lts-headers man-db dhcpcd dhclient ttf-font openssh zsh yay networkmanager nm-connection-editor openvpn wireless_tools iw crda linux-firmware python python-pip unzip xorg xorg-xinit xterm i3-gaps dmenu i3status nitrogen volumeicon network-manager-applet keepassxc ffmpeg zip unzip ethtool proxychains nautilus tcpdump ranger feh xfce4-power-manager htop alsa-utils pavucontrol dnsmasq darkhttpd libbde wireshark-qt tmux ntfs-3g xfce4-terminal lsof sshfs git ttf-liberation dnsutils python2-virtualenv syncthing rust neovim firefox chromium code adobe-source-code-pro-fonts yay pipewire wireplumber pipewire-alsa vlc jq gron rust-src qemu pv p7zip sway xdg-desktop-portal xdg-desktop-portal-wlr grim slurp wl-clipboard libvshadow swaylock wtype python-virtualenv csvkit pipewire-jack fuzzel libnotify ffmpeg bolt filezilla qemu xpdf neofetch netcat swaybg mako mercurial meson xfce4-terminal noto-fonts wqy-microhei wqy-zenhei nfs-utils zellij yadm starship exa ttf-hack-nerd choose bat zoxide kitty"
PACMAN_OPTIONAL_PACKAGES="discord"
YAY_ESSENTIAL_PACKAGES="wl-mirror liblnk-tools-git wdisplays libcaption-git obs-replay-source brave-bin gdk-pixbuf gruvbox-dark-gtk gruvbox-dark-icons-gtk dua"

###############################################################

echo 'installing pacman upgrades...'

sudo pacman -Syu --noconfirm

###############################################################

for package in $PACMAN_ESSENTIAL_PACKAGES $PACMAN_OPTIONAL_PACKAGES; do
    sudo pacman -S $package --needed --noconfirm 2>&1 | grep -iv ' skipping$\|there is nothing to do'
done

###############################################################

if ! [ -z $INSTALL_HACKING_PACKAGES ]; then
	echo 'installing hacking packages...'
	cat /etc/pacman.conf | grep -i 'blackarch'
	if [ $? -ne 0 ]; then
		echo 'installing blackarch repository...'
		sudo mkdir -p /root/Downloads
		sudo curl -O https://blackarch.org/strap.sh --output-dir /root/Downloads
		sudo chmod +x /root/Downloads/strap.sh
		sudo /root/Downloads/strap.sh
		sudo rm /root/Downloads/strap.sh
	fi
	for package in $PACMAN_SECURITY_PACKAGES; do
            sudo pacman -S $package --needed 2>&1 | grep -iv ' skipping$\|there is nothing to do'
        done
fi
