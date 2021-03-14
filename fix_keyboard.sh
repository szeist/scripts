#!/bin/bash

KEYCHRON_IDS=$(xinput --list | grep "keyboard" | grep "Keychron K2 Keyboard" | sed -e 's/^.*id=\([0-9]\+\).*$/\1/')

for ID in ${KEYCHRON_IDS}; do
  setxkbmap -layout us -variant colemak -device ${ID} -option caps:capslock,grp:shift_caps_toggle
done

