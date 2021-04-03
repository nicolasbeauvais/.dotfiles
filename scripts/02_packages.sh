# Add RPM Fusion, free and non-free
sudo dnf install -y \
"https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
"https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# Add FlatHub to FlatPak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install 1password RPM
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo sh -c 'echo -e "[1password]\nname=1Password\nbaseurl=https://downloads.1password.com/linux/rpm\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://downloads.1password.com/linux/keys/1password.asc" > /etc/yum.repos.d/1password.repo'

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
sudo dnf update -y

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
     mozilla-fira-sans-fonts \
     gnome-tweak-tool \
     jetbrains-mono-fonts \
     opera-stable \
     php-8.0.3 \
     podman \
     zsh

# Media codecs
sudo dnf group upgrade --with-optional Multimedia

# Install FlatPak programs
flatpak install flathub \
    com.discordapp.Discord \
    org.signal.Signal \
    com.slack.Slack \
    com.spotify.Client

# Configure Docker
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker


# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/bin/composer

# Configure Opera
sudo rm /usr/lib64/opera/libffmpeg.so

URL=`curl https://github.com/iteufel/nwjs-ffmpeg-prebuilt/releases/latest`
FFMPEGVER=${URL%\"*}
FFMPEGVER=${FFMPEGVER##*/}
FFMPEGZIP=${FFMPEGVER}-linux-x64.zip

curl -L -O https://github.com/iteufel/nwjs-ffmpeg-prebuilt/releases/download/${FFMPEGVER}/${FFMPEGZIP}
unzip ${FFMPEGZIP}
rm ${FFMPEGZIP}

sudo mv libffmpeg.so /usr/lib64/libffmpeg_h264.so
sudo ln -s /usr/lib64/libffmpeg_h264.so /usr/lib64/opera/libffmpeg.so
