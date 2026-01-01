#!/data/data/com.termux/files/usr/bin/bash
set -e

### CONFIG ###
CHROOT=/data/local/linux
USER=desktop
ROOTFS_URL="https://cdimage.ubuntu.com/ubuntu-base/releases/24.04/release/ubuntu-base-24.04-base-arm64.tar.gz"

echo "[*] Updating Termux..."
pkg update -y
pkg upgrade -y

echo "[*] Installing Termux packages..."
pkg install -y \
  x11-repo root-repo \
  pulseaudio \
  wget tar \
  tsu \
  xorg-xhost \
  termux-x11-nightly

echo "[*] Preparing chroot directory..."
sudo mkdir -p $CHROOT

if [ ! -f "$CHROOT/.golden-installed" ]; then
  echo "[*] Downloading rootfs..."
  wget -O /tmp/rootfs.tar.gz "$ROOTFS_URL"

  echo "[*] Extracting rootfs..."
  sudo tar -xpf /tmp/rootfs.tar.gz -C $CHROOT

  sudo touch $CHROOT/.golden-installed
fi

echo "[*] Mounting system dirs..."
sudo mount -o bind /dev  $CHROOT/dev  || true
sudo mount -o bind /sys  $CHROOT/sys  || true
sudo mount -o bind /proc $CHROOT/proc || true

echo "[*] Installing packages inside chroot..."
sudo chroot $CHROOT /bin/bash <<EOF
apt update
apt install -y \
  supervisor \
  dbus-x11 \
  policykit-1 \
  xfce4 \
  xfce4-goodies \
  xterm \
  pulseaudio-utils

id $USER >/dev/null 2>&1 || useradd -m -s /bin/bash $USER
echo "$USER:$USER" | chpasswd
EOF

echo "[*] Configuring PulseAudio client..."
sudo mkdir -p $CHROOT/etc/pulse
cat <<EOF | sudo tee $CHROOT/etc/pulse/client.conf
default-server = tcp:127.0.0.1
autospawn = no
EOF

echo "[*] Installing desktop session script..."
cat <<'EOF' | sudo tee $CHROOT/usr/local/bin/start-desktop.sh
#!/bin/sh
export XDG_RUNTIME_DIR=/tmp/runtime-$USER
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

export PULSE_SERVER=tcp:127.0.0.1

# user polkit
if ! pgrep -u "$USER" polkitd >/dev/null; then
  /usr/lib/policykit-1/polkitd &
fi

exec xfce4-session
EOF
sudo chmod +x $CHROOT/usr/local/bin/start-desktop.sh

echo "[*] Configuring supervisor..."
sudo mkdir -p $CHROOT/etc/supervisor/conf.d
cat <<EOF | sudo tee $CHROOT/etc/supervisor/conf.d/xsession.conf
[program:xsession]
user=$USER
environment=DISPLAY=:0,HOME=/home/$USER
command=/bin/sh -c "exec dbus-run-session /usr/local/bin/start-desktop.sh"
autorestart=true
EOF

echo "[*] Installing Termux launcher..."
mkdir -p .shortcuts
cat <<'EOF' > $HOME/.shortcuts/GUI
#!/bin/sh

pulseaudio --kill || true
pulseaudio --start \
  --exit-idle-time=-1 \
  --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1"

termux-x11 :0 &

sleep 3

sudo chroot /data/local/linux /usr/bin/supervisord -n
EOF

chmod +x $PREFIX/bin/start-desktop

echo "[✓] INSTALLER v1.0 COMPLETE"
echo "Run desktop with: start-desktop"
