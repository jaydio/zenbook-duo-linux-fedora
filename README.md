# Linux for the ASUS Zenbook Duo

A script to manage features on the Zenbook Duo.

## Functionality Status

| Feature | Working | Not Working |
|---------|:-------:|:-----------:|
| Toggle bottom screen on when keyboard removed | ✅ | |
| Toggle bottom screen off when keyboard placed on | ✅ | |
| Toggle bluetooth on when keyboard removed | ✅ | |
| Toggle bluetooth off when keyboard placed on (if bluetooth was off when removed) | ✅ | |
| Screen brightness sync | ✅ | |
| Reset Airplane mode when keyboard removed/placed (handles issue where Ubuntu toggles it on/off) | ✅ | |
| Keyboard backlight set on boot and/or keyboard placed | ✅ | |
| Checks for correct state on boot/resume (from suspend and hibernate)| ✅ | |
| Auto rotation | ✅ | |
| Keyboard backlight when keyboard connected via BT | | ❌ |
| Keyboard function keys (none seem to work in BT mode) | | ❌ |

## Tested on

The following models and operating systems have been validated by users

- **Models**
    - 2025 Zenbook Duo (UX8406CA)

- **Distros**
    - Fedora 42

## Install

Run the setup script below, choose a default keyboard backlight level of 0 (off) to 3 (high), and a default resolution scale.

```bash
$ ./setup.sh 
What would you like to use for the default keyboard backlight brightness [0-3]? 1
What would you like to use for monitor scale (1 = 100%, 1.5 = 150%, 2=200%) [1-2]? 1
...
<watch it install>
```

**Notes:**

1. Review the `setup.sh` and `duo.sh` scripts before proceeding with installation.
2. After installation is complete, log out and log back into your user session for changes to take effect. Alternatively, reboot your machine, ensuring the keyboard is connected during boot.

This will configure the necessary systemd scripts to manage the functionality described above. A log file will be generated in `/tmp/duo/` while the services are active.
