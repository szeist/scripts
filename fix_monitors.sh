#!/bin/bash

DISPLAYPORT_COUNT=$(xrandr -q | grep "^DP.* connected" | wc -l)
HDMI_COUNT=$(xrandr -q | grep "^HDMI.* connected" | wc -l)
LID_OPEN=$(cat /proc/acpi/button/lid/LID/state | grep open | wc -l)

declare -A DISPLAYS 
DISPLAYS[eDP-1]='--mode 1920x1080 -r 60'
DISPLAYS[HDMI-1]='--off'
DISPLAYS[HDMI-2]='--off'
DISPLAYS[DP-1]='--off'
DISPLAYS[DP-2-1]='--off'
DISPLAYS[DP-2-2]='--off'

if [ $LID_OPEN -eq 0 ]; then
    DISPLAYS[eDP-1]='--off'
fi

if [ $DISPLAYPORT_COUNT -eq 2 ]; then
    DISPLAYS[DP-2-2]='--right-of eDP-1 --mode 1920x1080 -r 60'
    DISPLAYS[DP-2-1]='--right-of DP-2-2 --mode 1920x1080 -r 60'
elif [ $DISPLAYPORT_COUNT -eq 1 ]; then
    DISPLAYS[DP-1]='--left-of eDP-1 --mode 3440x1440 -r 100'
elif [ $HDMI_COUNT -eq 1 ]; then
    DISPLAYS[HDMI-2]='--left-of eDP-1 --auto'
fi

command='xrandr'
for display in ${!DISPLAYS[@]}; do
    command="${command} --output ${display} ${DISPLAYS[$display]}"
done

$command