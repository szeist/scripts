#!/bin/sh

FPRINT_DEVICE='1-9'

LID_OPEN=$(cat /proc/acpi/button/lid/LID/state | grep open | wc -l)

if [ $LID_OPEN -eq 1 ]; then
  STATE='1';
elif [ $LID_OPEN -eq 0 ]; then
  STATE='0';
else
  echo "Unknown LID_OPEN state: ${LID_OPEN}" >&2
  exit 1
fi

echo $STATE | sudo /usr/bin/tee "/sys/bus/usb/devices/${FPRINT_DEVICE}/authorized"
