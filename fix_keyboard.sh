#!/bin/bash

KEYCHRON_ID=$(xinput --list | grep 'Keychron Keychron Q1 \(Keyboard\)\?\s\+id=' | sed -e 's/^.*id=\([0-9]\+\).*$/\1/')

setxkbmap -layout us -variant colemak
if [ -n "${KEYCHRON_ID}" ]; then
  for i in ${KEYCHRON_ID}; do
    setxkbmap -device ${i} -layout us;
  done
fi
