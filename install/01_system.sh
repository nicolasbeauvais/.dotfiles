#
# Set hostname
#
hostnamectl set-hostname "$HOSTNAME"

#
# Optimize BTRFS
#
# https://mutschler.eu/linux/install-guides/fedora-post-install/#btrfs-filesystem-optimizations
#
sudo sed -i '/\sbtrfs\s/s/\s0\s0$/,ssd,noatime,space_cache,commit=120,compress=zstd,discard=async 0 0/' /etc/fstab

#
# Regenerate grub2 config
#
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg


#
# Configure DNS
#
sudo sed -i 's/#DNS=/DNS=1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001/' /etc/systemd/resolved.conf
sudo sed -i 's/#DNSSEC=no/DNSSEC=true/' /etc/systemd/resolved.conf

rm /etc/resolv.conf

cat <<EOT >> /etc/resolv.conf
# Original file symlink to ../run/systemd/resolve/stub-resolv.conf
nameserver 1.0.0.1
nameserver 1.1.1.1
EOT

service systemd-resolved restart

#
# Optimize DNF
#
# https://mutschler.eu/linux/install-guides/fedora-post-install/#dnf-flags
#
echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf
