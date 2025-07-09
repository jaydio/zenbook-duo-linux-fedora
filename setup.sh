#!/bin/bash

INSTALL_LOCATION=/usr/local/bin/duo

DEV_MODE=false
DEV_INSTALL_LOCATION=/data/repos/nowsci/zenbook-duo-linux/duo.sh

DEFAULT_BACKLIGHT=1
DEFAULT_SCALE=1

if [ "${1}" = "--dev-mode" ]; then
    DEV_MODE=true
    INSTALL_LOCATION=${DEV_INSTALL_LOCATION}
fi

if [ "${DEV_MODE}" = false ]; then
    read -p "What would you like to use for the default keyboard backlight brightness [0-3]? " DEFAULT_BRIGHTNESS
    read -p "What would you like to use for monitor scale (1 = 100%, 1.5 = 150%, 2=200%) [1-2]? " DEFAULT_SCALE
    sudo dnf install -y \
    inotify-tools \
    usbutils \
    python3-pyusb \
    iio-sensor-proxy \
    NetworkManager \
    gnome-settings-daemon \
    rfkill \
    gdb \
    coreutils \
    dbus-tools \
    notify-send

    # mutter-common-bin does not exist in Fedora, so this line is omitted.

    sudo mkdir -p /usr/local/bin
    sudo cp ./duo.sh ${INSTALL_LOCATION}
    sudo chmod a+x ${INSTALL_LOCATION}
    sudo sed -i "s/DEFAULT_BACKLIGHT=1/DEFAULT_BACKLIGHT=${DEFAULT_BRIGHTNESS}/g" ${INSTALL_LOCATION}
    sudo sed -i "s/DEFAULT_SCALE=1/DEFAULT_SCALE=${DEFAULT_SCALE}/g" ${INSTALL_LOCATION}
fi

function addSudoers() {
    RESULT=$(sudo grep "${1}" /etc/sudoers)
    if [ -z "${RESULT}" ]; then
        echo "${1}" | sudo tee -a /etc/sudoers
    fi
}

PYTHON3=$(which python3)
if [ -n "${PYTHON3}" ] && [ -n "${USER}" ]; then
    addSudoers "${USER} ALL=NOPASSWD:${PYTHON3} /tmp/duo/backlight.py *"
    addSudoers "${USER} ALL=NOPASSWD:/usr/bin/tee /sys/class/backlight/card1-eDP-2-backlight/brightness"
fi

sudo rm -f /lib/systemd/system-sleep/duo
sudo ln -s ${INSTALL_LOCATION} /lib/systemd/system-sleep/duo

echo "[Unit]
Description=Zenbook Duo Power Events Handler (boot & shutdown)
DefaultDependencies=no
Before=shutdown.target
After=multi-user.target

[Service]
Type=oneshot
ExecStart=${INSTALL_LOCATION} boot
ExecStop=${INSTALL_LOCATION} shutdown
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/zenbook-duo.service

echo "[Unit]
Description=Zenbook Duo User Handler
After=graphical-session.target

[Service]
ExecStart=${INSTALL_LOCATION}
Restart=no
Environment=XDG_CURRENT_DESKTOP=GNOME

[Install]
WantedBy=default.target
" | sudo tee /etc/systemd/user/zenbook-duo-user.service

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable zenbook-duo.service
systemctl --user daemon-reexec
systemctl --user daemon-reload
sudo systemctl --global enable zenbook-duo-user.service

echo "Install complete."
