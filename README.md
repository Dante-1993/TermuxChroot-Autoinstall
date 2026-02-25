# Dante Termux Chroot

Full lifecycle Debian/Ubuntu desktop environment for Termux using real chroot.

Provides XFCE desktop, SSH server, cron scheduler and full service bootstrap.

---

## Features

- Full chroot environment (Debian / Ubuntu)
- XFCE desktop via Termux:X11
- PulseAudio integration
- SSH server auto start
- Cron auto start
- Lifecycle scripts (install / start / stop / uninstall)
- Automatic mounts
- Clean shutdown
- Termux shortcuts
- ASCII banner
- Service bootstrap without systemd

---

## Architecture

This project uses busybox chroot with bind mounts and a pseudo init system.

Termux → Busybox → Chroot → Services → XFCE


Systemd is not used. Services are started via init scripts.

---

## Requirements

- Rooted Android device
- Termux
- Termux:X11
- tsu / sudo
- busybox magisk module

---

## Installation

```bash
chmod +x setup.sh
./setup.sh
```


⚡ Optional GPU acceleration

If virgl is installed:

Umcomment virgl_test_server_android & in start script

Otherwise software rendering will be used.


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

Planned to add support of other DE and PRoot version for users without rooted phone

Use at your own risk.
Running Linux environments with root privileges may affect device stability.
