#!/data/data/com.termux/files/usr/bin/bash

set -e

CHROOT_DIR="/data/local/debian"
USERNAME="dante"

echo "[+] Installing Termux deps..."
pkg update -y
pkg install -y root-repo x11-repo
pkg install -y sudo wget xz-utils pulseaudio termux-x11-nightly dbus

if ! command -v debootstrap >/dev/null 2>&1; then
    pkg install -y debootstrap
fi

echo "[+] Creating rootfs..."
sudo mkdir -p $CHROOT_DIR

echo "[+] Bootstrapping Debian 13 (trixie)..."
sudo debootstrap --arch=arm64 --variant=minbase trixie /data/local/debian http://deb.debian.org/debian

echo "[+] Configuring base system..."

sudo chroot $CHROOT_DIR /bin/bash -c "
apt update
apt install -y xfce4 xfce4-goodies dbus-x11 runit openssh-server sudo \
gvfs gvfs-daemons gvfs-backends policykit-1 xclip

echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
locale-gen

useradd -m -s /bin/bash $USERNAME
echo '$USERNAME ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

mkdir -p /var/run/sshd
"

echo "[+] Creating run script..."

cat << 'EOF' > ~/start-debian-desktop.sh
#!/data/data/com.termux/files/usr/bin/bash

set -e

CHROOT_DIR="/data/local/debian"
USERNAME="dante"
USE_UNSHARE=0   # change to 1 if kernel supports

echo "[+] Killing old sessions..."
killall -9 termux-x11 Xwayland pulseaudio virgl_test_server_android 2>/dev/null || true

echo "[+] Starting Termux X11..."
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity

sleep 2

echo "[+] Starting X11 server..."
XDG_RUNTIME_DIR=${TMPDIR} termux-x11 :0 -ac &

sleep 3

echo "[+] Starting PulseAudio..."
pulseaudio --start --exit-idle-time=-1
pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1

echo "[+] Mounting filesystems..."
sudo mount --bind /dev $CHROOT_DIR/dev || true
sudo mount --bind /dev/pts $CHROOT_DIR/dev/pts || true
sudo mount -t proc proc $CHROOT_DIR/proc || true
sudo mount -t sysfs sys $CHROOT_DIR/sys || true
sudo mount -t tmpfs tmpfs $CHROOT_DIR/run || true
sudo mount -t tmpfs tmpfs $CHROOT_DIR/tmp || true

echo "[+] Mounting storage..."
sudo mkdir -p $CHROOT_DIR/mnt/shared
sudo mount --bind /sdcard $CHROOT_DIR/mnt/shared || true

sudo cp /etc/resolv.conf $CHROOT_DIR/etc/resolv.conf || true

echo "[+] Launching desktop..."

if [ "$USE_UNSHARE" = "1" ]; then
  sudo unshare --mount --uts --ipc --pid --fork --mount-proc \
  chroot $CHROOT_DIR /bin/bash -c "
  export DISPLAY=:0
  export PULSE_SERVER=tcp:127.0.0.1
  su - $USERNAME -c '
  dbus-launch startxfce4
  '
  "
else
  sudo chroot $CHROOT_DIR /bin/bash -c "
  export DISPLAY=:0
  export PULSE_SERVER=tcp:127.0.0.1
  su - $USERNAME -c '
  dbus-launch startxfce4
  '
  "
fi
EOF

chmod +x ~/start-debian-desktop.sh

mkdir -p ~/.shortcuts
echo "~/start-debian-desktop.sh" > ~/.shortcuts/debian-desktop
chmod +x ~/.shortcuts/debian-desktop

echo ""
echo "✅ Desktop environment installed!"
echo "Run with:"
echo "   ~/start-debian-desktop.sh"
