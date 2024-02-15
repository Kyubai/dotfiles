#!/bin/bash

# PACMAN_HACKING_PACKAGES="responder cdrkit qemu-headless nbd pwndrop crackmapexec impacket bloodhound metasploit hashcat seclists burpsuite chisel nmap recon-ng wpscan libpff dc3dd dislocker john ghidra radare2 squashfs-tools libewf chntpw hydra"
# PACMAN_ESSENTIAL_PACKAGES="net-tools base-devel vim linux-lts-headers man-db dhcpcd dhclient ttf-font openssh zsh yay networkmanager nm-connection-editor openvpn wireless_tools iw crda linux-firmware python python-pip unzip xorg xorg-xinit xterm i3-gaps dmenu i3status nitrogen volumeicon network-manager-applet keepassxc ffmpeg zip unzip ethtool proxychains nautilus tcpdump ranger feh xfce4-power-manager htop alsa-utils pavucontrol dnsmasq darkhttpd libbde wireshark-qt tmux ntfs-3g xfce4-terminal lsof sshfs git ttf-liberation dnsutils python2-virtualenv syncthing rust neovim firefox chromium code adobe-source-code-pro-fonts yay pipewire wireplumber pipewire-alsa vlc jq gron rust-src qemu pv p7zip sway xdg-desktop-portal xdg-desktop-portal-wlr grim slurp wl-clipboard libvshadow swaylock wtype python-virtualenv csvkit pipewire-jack fuzzel libnotify ffmpeg bolt filezilla qemu xpdf neofetch netcat swaybg mako mercurial meson xfce4-terminal noto-fonts wqy-microhei wqy-zenhei nfs-utils zellij yadm starship exa ttf-hack-nerd choose bat zoxide kitty"
# PACMAN_OPTIONAL_PACKAGES="discord"
# YAY_ESSENTIAL_PACKAGES="wl-mirror liblnk-tools-git wdisplays libcaption-git obs-replay-source brave-bin gdk-pixbuf gruvbox-dark-gtk gruvbox-dark-icons-gtk dua"

APT_ESSENTIAL_PACKAGES="bat neovim"
CARGO_ESSENTIAL_PACKAGES="starship eza zellij"

###############################################################

echo 'adding required repositories...'
sudo add-apt-repository ppa:neovim-ppa/unstable -y

echo 'installing apt upgrades...'
sudo apt update -y && apt upgrade -y

###############################################################

echo "installing cargo packages..."
cargo install $CARGO_ESSENTIAL_PACKAGES

echo "installing apt packages..."
sudo apt install $APT_ESSENTIAL_PACKAGE $APT_OPTIONAL_PACKAGES -y

###############################################################

echo "configuring system..."
ln -s /usr/bin/batcat /usr/local/bin/bat

echo "apt module finished"
