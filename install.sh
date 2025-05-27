#!/bin/bash

HOSTNAME=ghost


print "\n\e[0;33mSystem setup\e[0m"

# ---

echo 'Set hostname'

hostnamectl set-hostname "$HOSTNAME"

# ---

echo 'Regenerate GRUB2 configuration'

sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# ---

print "\n\e[0;Packages setup\e[0m"


# ---

echo 'Install DNF plugins core'

sudo dnf install -y dnf-plugins-core

# ---

echo 'Import CloudFlare warp repository'

curl -fsSl https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo | sudo tee /etc/yum.repos.d/cloudflare-warp.repo

# ---

echo "Import Remi's RPM repository"

sudo dnf install https://rpms.remirepo.net/fedora/remi-release-41.rpm
sudo rpm --import "/etc/pki/rpm-gpg/RPM-GPG-KEY-remi-$(rpm -E %fedora)"

# ---

echo "Import Hashicorp repository"

sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo

# ---

echo "Import Stripe repository"

sudo echo -e "[Stripe]\nname=stripe\nbaseurl=https://packages.stripe.dev/stripe-cli-rpm-local/\nenabled=1\ngpgcheck=0" >> /etc/yum.repos.d/stripe.repo

# ---

echo 'Install Flathub'

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# ---

echo 'Uninstall unused packages'

# eog: Eye of Gnome image viewer
# evince: Document viewer
# simple-scan: Document scanner
# totem: ideos
sudo dnf remove -qy \
    eog \
    evince \
    gedit \
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
    ptyxis \
    rhythmbox \
    simple-scan \
    totem

# ---

echo 'Upgrade DNF'

sudo dnf upgrade --refresh -qy

# ---

echo 'Install DNF packages'

sudo dnf install -qy \
     cloudflare-warp
     crontabs \
     dconf \
     dconf-editor \
     fastfetch \
     ffmpeg \
     fish \
     gnome-console \
     golang \
     jetbrains-mono-fonts \
     jq \
     make \
     nodejs \
     php-cli \
     php83 \
     php-bcmath \
     php-dbg \
     php-gd \
     php-mbstring \
     php-mysqlnd \
     php-opcache \
     php-pdo \
     php-process \
     php-xml \
     php-zip \
     pip \
     rclone \
     setroubleshoot \
     terraform \
     util-linux-user \
     zoxide

# ---

echo 'Install Ghost CLI'

(cd "$HOME/.dotfiles/cli" && pip install -r requirements.txt && pip install --editable . || exit)

# ---

echo 'Install Composer'

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/bin/composer

# ---

echo 'Install pyenv'

curl https://pyenv.run | bash

# ---

echo 'Install starship prompt'

curl -sS https://starship.rs/install.sh | sh

ln -s "$HOME/.dotfiles/files/starship.toml" "$HOME/.config/starship.toml"

# ---

echo 'Set Fish as default shell'

chsh -s /usr/bin/fish

# ---

echo 'Symlink Fish configuration'

rm -rf "$HOME/.config/fish"
ln -s "$HOME/.dotfiles/files/fish" "$HOME/.config/fish"

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

echo 'Enable FSTrimTimer Service...'

sudo systemctl enable fstrim.timer

# ---

echo 'Enable Crond Service...'

sudo systemctl enable crond.service

# ---

print "\n\e[0;Files backup\e[0m"

# ---

echo 'Create backup cron script...'


cat <<EOT >> /tmp/system_backup.sh
# Run gst backup
gst backup:nas
EOT

sudo mv /tmp/system_backup.sh /etc/cron.daily/system_backup.sh

sudo chmod +x /etc/cron.daily/system_backup.sh
sudo chown root:root /etc/cron.daily/system_backup.sh

# ---

echo 'Install AWS CLI'

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws/ awscliv2.zip

# ---

echo 'Configure Cloudflare warp'

warp-cli registration new
warp-cli connect
warp-cli mode warp+doh

# ---

echo 'Configure Gnome'

cat dconf-settings.ini | dconf load /

# ---

echo 'Symlink wallpaper directory'

ln -s "$HOME/.dotfiles/files/wallpapers" "$HOME/Pictures/wallpapers"

# ---

print "\n\e[0;Cleanup\e[0m"

# ---

rm -rf "$HOME/.bash_history" \
   "$HOME/.bash_logout" \
   "$HOME/.bash_profile" \
   "$HOME/.bashrc" \
   "$HOME/clone.sh" \
   "$HOME/Desktop" \
   "$HOME/Public" \
   "$HOME/Templates"

sudo dnf remove

# ---

print "\n\e[0;Done\e[0m"
