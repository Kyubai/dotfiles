echo 'Start installation of guest module'
pacman_vboxguest="virtualbox-guest-utils xf86-video-vmware gtk2"

# systemctl enable vboxservice
# systemctl start vboxservice

# usermod -G vboxsf $USER

# for package in $pacman_vboxguest; do pacman -S $package --noconfirm --needed; done

sed -i 's,set \$mod Mod.*$,set \$mod Mod1,g' $user_dir/.config/i3/config

echo $user_dir

echo 'Finished installation of guest module'
