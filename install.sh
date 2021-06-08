#!/bin/bash

HOSTNAME=ghost


print "\n\e[0;33mSystem setup\e[0m"

# ---

echo 'Set hostname...'

hostnamectl set-hostname "$HOSTNAME"

# ---

echo 'Optimize BTRFS filesystem...'

# https://mutschler.eu/linux/install-guides/fedora-post-install/#btrfs-filesystem-optimizations
sudo sed -i '/\sbtrfs\s/s/\s0\s0$/,ssd,noatime,space_cache,commit=120,compress=zstd,discard=async 0 0/' /etc/fstab

# ---

echo 'Regenerate GRUB2 configuration...'

sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

# ---

echo 'Configure DNS with CloudFlare 1.1.1.1...'

sudo sed -i 's/#DNS=/DNS=1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001/' /etc/systemd/resolved.conf
sudo sed -i 's/#DNSSEC=no/DNSSEC=true/' /etc/systemd/resolved.conf

rm /etc/resolv.conf

cat <<EOT >> /etc/resolv.conf
# Original file symlink to ../run/systemd/resolve/stub-resolv.conf
nameserver 1.0.0.1
nameserver 1.1.1.1
EOT

service systemd-resolved restart

# ---

echo 'Optimize DNF...'

# https://mutschler.eu/linux/install-guides/fedora-post-install/#dnf-flags
echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf

# ---

print "\n\e[0;Packages setup\e[0m"

# ---

echo 'Uninstall unused packages...'

# eog: Eye of Gnome
# evince: Document viewer
# simple-scan: Document scanner
# totem: ideos
sudo dnf remove -qy \
    eog \
    evince \
    firefox \
    gedit \
    gnome-boxes \
    gnome-calculator \
    gnome-calendar \
    gnome-characters \
    gnome-clocks \
    gnome-contacts \
    gnome-font-viewer \
    gnome-maps \
    gnome-online-miners \
    gnome-photos \
    gnome-remote-desktop \
    gnome-shell-extension-background-logo\
    gnome-tour \
    gnome-user-share \
    gnome-video-effects \
    gnome-weather \
    ibus-anthy \
    'libreoffice-*' \
    rhythmbox \
    simple-scan \
    totem

# ---

echo 'Install RPM Fusion...'

sudo dnf install -qy \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# ---

echo 'Install Flathub...'

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# ---

echo "Install Remi's RPM repository..."

sudo dnf install -y "https://rpms.remirepo.net/fedora/remi-release-$(rpm -E %fedora).rpm"
sudo dnf config-manager --set-enabled remi
sudo dnf config-manager --set-enabled remi-php80
sudo dnf config-manager --set-disabled remi-modular
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2017
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2018
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2019
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2020
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2021
sudo rpm --import "/etc/pki/rpm-gpg/RPM-GPG-KEY-remi-$(rpm -E %fedora)"

# ---

echo 'Upgrade DNF...'

sudo dnf upgrade --refresh -qy

# ---

echo 'Install DNF packages...'

sudo dnf install -qy \
     1password \
     cronie \
     dconf \
     dconf-editor \
     dnf-plugins-core \
     docker \
     docker-compose \
     emacs \
     ffmpeg \
     gnome-tweak-tool \
     imagemagick \
     jetbrains-mono-fonts \
     jq \
     kitty \
     kitty-terminfo \
     mariadb \
     mariadb-server \
     mozilla-fira-sans-fonts \
     nodejs \
     parallel \
     php-8.0.3 \
     php-gd \
     php-zip \
     php-pecl-swoole \
     policycoreutils-gui \
     rclone \
     setroubleshoot \
     util-linux-user \
     virtualenv \
     zsh

# ---

echo 'Install Flatpack packages...'

flatpak install flathub -y \
    com.axosoft.GitKraken
    com.discordapp.Discord \
    com.jetbrains.PhpStorm \
    org.signal.Signal \
    com.slack.Slack \
    com.spotify.Client \
    io.exodus.Exodus

# ---

echo 'Install Ghost CLI...'

(
  cd "$HOME/.dotfiles/cli
  && pip install -r requirements.txt
  && pip install --editable ." || exit
)

# ---

echo 'Install Composer...'

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/bin/composer


# ---

echo 'Install Yarn...'

sudo npm install --global yarn

# ---

echo 'Install Emacs DOOM...'

git clone --depth 1 https://github.com/hlissner/doom-emacs "$HOME/.emacs.d"

ln -s "$HOME/.dotfiles/files/.doom.d" "$HOME/.doom.d"

"$HOME/.emacs.d/bin/doom install"

# ---

echo 'Install Prezto...'

git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"
git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/belak/prezto-contrib "$HOME/.zprezto/contrib"

for rcfile in "$HOME/.dotfiles/files/prezto/runcoms/*"; do
    ln -s "$rcfile" "$HOME/.${rcfile:t}"
done

for module in "$HOME"/.dotfiles/files/prezto/modules/*; do
    ln -s "$module" "$HOME/.zprezto/modules/${module:t}"
done

# ---

echo 'Remove invalid which2 profile...'

sudo rm /etc/profile.d/which2.sh

# ---

echo 'Set ZSH as default shell...'

chsh -s "$(which zsh)"

# ---

echo 'Setup Kitty...'

ln -s "$HOME/.dotfiles/files/kitty" "$HOME/.config/kitty"

# ---

echo 'Setup custom keyboard layout...'

ln -s "$HOME/.dotfiles/install/keyboard/dp" "/usr/share/X11/xkb/symbols/dp"

# @TODO: Modify /usr/share/X11/xkb/rules/base.lst
# @TODO: Modify /usr/share/X11/xkb/rules/base.xml
# @TODO: Modify /usr/share/X11/xkb/rules/evdev.lst
# @TODO: Modify /usr/share/X11/xkb/rules/evdev.xml

# @TODO: Set as default keyboard

# ---

echo 'DNF autoremove'

sudo dnf -q autoremove

# ---

echo 'Firmware update...'

sudo fwupdmgr get-devices
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates
sudo fwupdmgr update

# ---

print "\n\e[0;Services setup\e[0m"

# ---

echo 'Enable Docker Service...'

sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker

# ---

echo 'Enable MariaDB Service...'

sudo mysql_secure_installation
sudo systemctl enable mariadb

# ---

echo 'Enable FSTrimTimer Service...'

sudo systemctl enable fstrim.timer

# ---

print "\n\e[0;Files backup\e[0m"

# ---

echo 'Register twice-daily backup cron...'

(crontab -l 2>/dev/null; echo "45 11,17 * * * gst backup:cloud") | crontab -


# ---

print "\n\e[0;Cleanup\e[0m"

# ---

rm -f "$HOME/.bash_history" \
   "$HOME/.bash_logout" \
   "$HOME/.bash_profile" \
   "$HOME/.bashrc" \
   "$HOME/clone.sh"

# ---

print "\n\e[0;Done\e[0m"
