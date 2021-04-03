#
# Set hostname
#
hostnamectl set-hostname "$HOSTNAME.localhost"

#
# Setup SSH
#
sudo chmod 600 ~/.ssh/id_ed25519
sudo chmod 600 ~/.ssh/id_rsa

sudo systemctl enable sshd
sudo systemctl start sshd

ssh-add ~/.ssh/id_ed25519

