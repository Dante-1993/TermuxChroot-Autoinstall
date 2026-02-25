#!/bin/sh

#Path of DEBIAN rootfs
DEBIANPATH="/data/local/tmp/chrootDebian"

# Fix setuid issue
busybox mount -o remount,dev,suid /data

busybox mount --bind /dev $DEBIANPATH/dev || true
busybox mount --bind /sys $DEBIANPATH/sys || true
busybox mount --bind /proc $DEBIANPATH/proc || true
busybox mount -t devpts devpts $DEBIANPATH/dev/pts || true

# /dev/shm for Electron apps
mkdir -p  $DEBIANPATH/dev/shm
busybox mount -t tmpfs -o size=256M tmpfs $DEBIANPATH/dev/shm || true

# Mount sdcard
mkdir $DEBIANPATH/sdcard
busybox mount --bind /sdcard $DEBIANPATH/sdcard

# chroot into DEBIAN
#busybox chroot $DEBIANPATH /bin/su - root
#busybox chroot $DEBIANPATH /bin/su - root -c 'export XDG_RUNTIME_DIR=${TMPDIR} && export PULSE_SERVER=tcp:127.0.0.1:4713 && sudo service dbus start && su - dante -c "env DISPLAY=:0 startxfce4"'
busybox chroot $DEBIANPATH /bin/su - droidmaster -c 'export DISPLAY=:0 && export PULSE_SERVER=127.0.0.1 &&  dbus-launch --exit-with-session startxfce4'
