!#/bin/bash

wget -q --spider http://google.com

if [ $? -eq 0 ]; then
    echo "Online."
else
    echo "Offline"
    ip link set enp4s0 up
    dhcpcd enp4s0
    sleep 2
fi

pacstrap /mnt base linux linux-firmware

# generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

#change root
arch-chroot /mnt

# (for BIOS systems)
#pacman -S grub efibootmgr
#grub-install /dev/sda
#grub-mkconfig -o /mnt/boot/grub/grub.cfg

# Enable network manager
pacman -S networkmanager
systemctl enable NetworkManager

#date and time
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo KEYMAP=us > /etc/vconsole.conf
echo human > /etc/hostname

pacman -S sudo

# Set new user
useradd -m human
passwd human
pacman -S sudo
echo 'human ALL=(ALL:ALL) ALL' >> /etc/sudoers

pacman -S dhcpcd vim openssh
systemctl enable sshd

pacman -S xf86-video-nouveau

#i3 install
pacman -S i3-gaps i3blocks i3lock i3status
#pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
pacman -S ly

pacman -S firefox xterm # nitrogen dmenu

#systemctl enable lightdm
systemctl enable ly.service

pacman -S fzf
echo 'Plug 'junegunn/fzf', { 'do': { -> fzf#install() }' >> ~/.vimrc

pacman -S base-devel zsh

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
