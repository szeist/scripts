#!/bin/bash

PRIMARY_DISPLAY='eDP1'
FOUND_DISPLAYS=$(xrandr -q | grep '\(dis\)\?connected' | cut -d' ' -f1,2)
LID_OPEN=$(cat /proc/acpi/button/lid/LID/state | grep open | wc -l)

declare -A DISPLAYS 

while IFS= read -r line; do
  read display connection <<< $line

  if [ "${connection}" == 'disconnected' ]; then
    DISPLAYS[$display]='--off'
    continue
  fi

  case $display in
    'eDP1'|'eDP-1')
      PRIMARY_DISPLAY=$display
      if [ $LID_OPEN -eq 0 ]; then
          DISPLAYS[$display]='--off'
      else
          DISPLAYS[$display]='--auto'
      fi
    ;;
  'DP-1'|'DP1-3')
    DISPLAYS[$display]="--left-of ${PRIMARY_DISPLAY} --mode 3440x1440 -r 100"
    ;;
  'HDMI*')
    DISPLAYS[$display]="--left-of ${PRIMARY_DISPLAY} --auto"
    ;;
  *)
    DISPLAYS[$display]='--off'
    ;;
  esac;
done <<< $FOUND_DISPLAYS

command='xrandr'
for display in ${!DISPLAYS[@]}; do
    command="${command} --output ${display} ${DISPLAYS[$display]}"
done

$command
