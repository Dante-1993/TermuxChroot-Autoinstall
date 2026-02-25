TermuxChroot-Autoinstall

Automated script to deploy a Debian chroot desktop environment on rooted Android using Termux, with XFCE, audio, clipboard integration, .

This project aims to provide a lightweight Linux workstation experience with standard services and networking.

✨ Features

Automated Debian (Trixie / 13) bootstrap

XFCE desktop environment

OpenSSH server

Crond

PulseAudio integration

Clipboard support

Auto DBus user session

Storage auto mount

Termux:X11 integration

One-command desktop launch

Termux shortcut integration

📋 Requirements

Rooted Android device

Termux installed (from F-Droid recommended)

Busybox Magisk module

Termux:X11 installed

Internet connection

At least 4–6 GB free storage

⚠️ Notes

This script requires root privileges.

Kernel namespace support is optional but recommended.

Performance depends on device hardware.

🚀 Installation

Clone the repository:

pkg update
pkg install git
git clone https://github.com/Dante-1993/TermuxChroot-Autoinstall.git
cd TermuxChroot-Autoinstall

Run installer:

chmod +x setup.sh

./setup.sh

The installation will:

Bootstrap Debian rootfs

Install XFCE and required packages

Create user for your choose

Configure audio and DBus

Create launch script


🖥️ Running the desktop

Start Termux:X11 app first, then run:

~/startxfce4_chrootDebian.sh


This will:

Start Termux X11 server

Start PulseAudio

Mount filesystems

Start DBus session

Launch XFCE desktop


🔐 SSH access

Inside chroot:

sudo service ssh start

Default port:

22
📂 Mounted paths
Host	Chroot
/sdcard	/mnt/shared
/dev	/dev
/proc	/proc
/sys	/sys

🔊 Audio

PulseAudio is bridged via TCP:

PULSE_SERVER=tcp:127.0.0.1

📋 Clipboard

Clipboard works via:

X11

DBus

xclip

⚡ Optional GPU acceleration

If virgl is installed:

Umcomment virgl_test_server_android & in start script

Otherwise software rendering will be used.

🛠️ Customization

You can modify:

Desktop environment

Username

Mount points

Services


🧨 Troubleshooting
Black screen

Restart Termux:X11 and run script again.

No audio

Restart PulseAudio:

pulseaudio --kill
pulseaudio --start


🧠 Architecture overview
Android kernel
   ↓
Termux
   ↓
Debian chroot
   ↓
XFCE

📊 What this project is NOT

Not a VM

Not Docker

Not full kernel virtualization

❤️ Contributing

Pull requests and improvements are welcome.

📜 License

GPLv3 License

⭐ Acknowledgements

Termux project 

Debian 

XFCE developers

[https://github.com/LinuxDroidMaster](https://github.com/LinuxDroidMaster/Termux-Desktops) LinuxDroidMaster, main scripts based on his repo

Future Plans

Planned to add support of other DE, uninstall script and PRoot version for users without rooted phone

Use at your own risk.
Running Linux environments with root privileges may affect device stability.
