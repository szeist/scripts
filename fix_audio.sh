#!/bin/bash

BT_HEADSET_MAC="08:C8:C2:97:6D:0E"

CARD_ID=$(echo "`pactl list cards`" | awk -v mac="$BT_HEADSET_MAC" '
BEGIN { RS = "\n\n"; FS = "\n" } 
$0 ~ mac { for (i = 1; i <= NF; i++) if ($i ~ /Card #/) print $i }' | grep -oP '(?<=#)\d+')

case "$1" in
  "bt-connect")
    bluetoothctl connect "${BT_HEADSET_MAC}"
    "${0}" bt-headphone
    ;;
  "bt-disconnect")
    bluetoothctl disconnect "${BT_HEADSET_MAC}"
    ;;
  "bt-headset")
    pactl set-card-profile "${CARD_ID}" "handsfree_head_unit"
    ;;
  "bt-headphone")
    pactl set-card-profile "${CARD_ID}" "a2dp_sink"
    ;;
  *)
    >&2 echo "Invalid command, usage: ${0} bt-(connect|disconnect|headset|headphone)"
esac
