#!/bin/sh

DEVICE_ID=$(xinput --list | grep "Expert Wireless TB Mouse" | sed -e 's/^.*id=\([0-9]\+\).*$/\1/')

xinput set-button-map ${DEVICE_ID} 8 3 1 4 5 6 7 2 9
