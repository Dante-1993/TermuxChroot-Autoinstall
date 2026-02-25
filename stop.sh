#!/data/data/com.termux/files/usr/bin/bash

set +e

CHROOT_DIR="/data/local/tmp/chrootDebian"

echo "=============================="
echo " Debian Chroot Stop Script"
echo "=============================="

echo "[+] Stopping desktop processes..."

su -c busybox chroot $CHROOT_DIR pkill xfce4-session 2>/dev/null
su -c busybox chroot $CHROOT_DIR pkill Xfce4-session 2>/dev/null
su -c busybox chroot $CHROOT_DIR pkill dbus-daemon 2>/dev/null
su -c busybox chroot $CHROOT_DIR pkill sshd 2>/dev/null

echo "[+] Killing local X apps..."
killall -9 xterm xclock xfce4-session 2>/dev/null

echo "[+] Stopping PulseAudio..."
pulseaudio --kill 2>/dev/null

echo "[+] Killing Termux X11..."
killall -9 termux-x11 Xwayland 2>/dev/null

echo "[+] Unmounting filesystems..."

su -c umount -lf $CHROOT_DIR/dev/pts 2>/dev/null
su -c umount -lf $CHROOT_DIR/dev/shm 2>/dev/null
su -c umount -lf $CHROOT_DIR/tmp 2>/dev/null
su -c umount -lf $CHROOT_DIR/proc 2>/dev/null
su -c umount -lf $CHROOT_DIR/sys 2>/dev/null
su -c umount -lf $CHROOT_DIR/dev 2>/dev/null
su -c umount -lf $CHROOT_DIR/sdcard 2>/dev/null

echo "[+] Checking remaining mounts..."

su -c mount | grep chrooDebian || echo "All mounts released ✅"

echo ""
echo "=============================="
echo " Chroot stopped"
echo "=============================="
