#!/bin/bash

DISPLAYPORT_COUNT=$(xrandr -q | grep "^DP.* connected" | wc -l)
HDMI_COUNT=$(xrandr -q | grep "^HDMI.* connected" | wc -l)
LID_OPEN=$(cat /proc/acpi/button/lid/LID/state | grep open | wc -l)

xrandr --output HDMI-1 --off
xrandr --output HDMI-2 --off
xrandr --output DP-2-1 --off
xrandr --output DP-2-2 --off

if [ $LID_OPEN -eq 0 ]; then
    xrandr --output eDP-1 --off
else
    xrandr --output eDP-1 --mode 1920x1080 -r 60
fi

if [ $DISPLAYPORT_COUNT -eq 2 ]; then
    xrandr --output DP-2-2 --right-of eDP-1 --mode 1920x1080 -r 60
    xrandr --output DP-2-1 --right-of DP-2-2 --mode 1920x1080 -r 60
fi

if [ $HDMI_COUNT -eq 1 ]; then
    xrandr --output HDMI-2 --left-of eDP-1 --mode 3440x1440 -r 30
fi
