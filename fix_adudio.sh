#!/bin/bash

BT_HEADSET_MAC="AC:12:2F:9D:5C:5B"

SINK="${1}"
BTUSB_LOADED=$(cat /proc/modules | grep -c btusb)

function enable_bluetooth_audio {
    sudo systemctl stop bluealsa.service
    sudo systemctl stop bluetooth.service
    [ $BTUSB_LOADED -ne 0 ] && sudo rmmod btusb
    sleep 1
    sudo modprobe btusb
    sudo systemctl start bluetooth.service
    sudo systemctl start bluealsa.service
    sleep 1
    bluetoothctl connect ${BT_HEADSET_MAC} 
    echo "pcm.!default bluealsa" > "${HOME}/.asoundrc"
    echo "ctl.!default bluealsa" >> "${HOME}/.asoundrc"
}

function disable_bluetooth_audio {
    systemctl is-active --quiet bluetooth && bluetoothctl disconnect AC:12:2F:9D:5C:5B
    sudo systemctl stop bluealsa.service
    [ $BTUSB_LOADED -ne 0 ] && sudo rmmod btusb
    rm -rf "${HOME}/.asoundrc"
}

case "${SINK}" in
  "bluetooth")
    [ -e "${HOME}/.asoundrc" ] || enable_bluetooth_audio
    ;;
  *)
    disable_bluetooth_audio
esac
