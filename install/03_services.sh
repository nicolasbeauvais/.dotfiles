# Configure Docker
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker

# Configure MariaDB
sudo mysql_secure_installation
sudo systemctl enable mariadb

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

# fstrim
sudo systemctl enable fstrim.timer

# SSH
sudo systemctl enable sshd
sudo systemctl start sshd
bash -c 'eval "$(ssh-agent -s)"'
ssh-add ~/.ssh/id_ed25519
