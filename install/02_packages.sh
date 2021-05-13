# Remove unused softwares
#
# eog: Eye of Gnome
# evince: Document viewer
# simple-scan: Document scanner
# totem: ideos
#
sudo dnf remove -y \
    eog \
    evince \
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

# Add RPM Fusion, free and non-free
sudo dnf install -y \
"https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
"https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# Add FlatHub to FlatPak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Opera RPM
sudo rpm --import https://rpm.opera.com/rpmrepo.key
sudo tee /etc/yum.repos.d/opera.repo <<RPMREPO
[opera]
name=Opera packages
type=rpm-md
baseurl=https://rpm.opera.com/rpm
gpgcheck=1
gpgkey=https://rpm.opera.com/rpmrepo.key
enabled=1
RPMREPO

# Add Remi's RPM repository
sudo dnf install -y https://rpms.remirepo.net/fedora/remi-release-$(rpm -E %fedora).rpm
sudo dnf config-manager --set-enabled remi
sudo dnf config-manager --set-enabled remi-php80
sudo dnf config-manager --set-disabled remi-modular
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2017
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2018
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2019
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2020
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2021
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi-$(rpm -E %fedora)

# Update repository
sudo dnf upgrade --refresh -y

# Install essential programs
sudo dnf install -y \
     1password \
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
     kitty \
     kitty-terminfo \
     mariadb \
     mariadb-server \
     mozilla-fira-sans-fonts \
     nodejs \
     opera-stable \
     parallel \
     php-8.0.3 \
     php-gd \
     php-zip \
     php-pecl-swoole \
     policycoreutils-gui \
     rclone \
     setroubleshoot \
     util-linux-user \
     zsh

# Media codecs
sudo dnf group upgrade -y --with-optional Multimedia

# Install FlatPak programs
flatpak install flathub -y \
    com.discordapp.Discord \
    io.exodus.Exodus \
    com.jetbrains.PhpStorm \
    org.signal.Signal \
    com.slack.Slack \
    com.spotify.Client

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/bin/composer

# Install Yarn
sudo npm install --global yarn

# Remove unused
sudo dnf autoremove

# Firmware update
sudo fwupdmgr get-devices
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates
sudo fwupdmgr update
