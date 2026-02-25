pkg update
pkg install x11-repo
pkg install root-repo
pkg install termux-x11-nightly
pkg update
pkg install tsu
pkg install pulseaudio
chmod +x ./install.sh
su -c ./install.sh
su -c chown $USER:$USER startxfce4_chrootDebian.sh
