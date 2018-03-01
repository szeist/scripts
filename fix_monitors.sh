#!/bin/bash

DISPLAYPORT_COUNT=$(xrandr -q | grep "^DP.* connected" | wc -l)
HDMI_COUNT=$(xrandr -q | grep "^HDMI.* connected" | wc -l)

xrandr --output HDMI-1 --off
xrandr --output HDMI-2 --off
xrandr --output DP-2-1 --off
xrandr --output DP-2-2 --off;

if [ $DISPLAYPORT_COUNT -eq 2 ]; then
    xrandr --output DP-2-1 --above eDP-1 --mode 1920x1080 -r 60
    xrandr --output DP-2-2 --above eDP-1 --left-of DP-2-1 --mode 1920x1080 -r 60
fi

if [ $HDMI_COUNT -eq 1 ]; then
    xrandr --output HDMI-2 --above eDP-1 --mode 1920x1080 -r 60
fi
