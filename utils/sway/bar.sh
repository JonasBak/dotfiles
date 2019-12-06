#!/bin/bash

TIME=$(date +'%H:%M')
DATE=$(date +'%d-%m-%Y')

BATTERY="⚡$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/percentage/{print $2}')"

VOLUME="🔉$(amixer sget Master | grep -oE "[0-9]{1,3}%" | head -n 1)"

player_status="$(playerctl status)"
if [[ "$player_status" == "Playing" ]]; then
  CURRENT_SONG="🎵$(playerctl metadata  --format "{{ title }} - {{ artist }}")"
fi

echo -e "$CURRENT_SONG $VOLUME $BATTERY $TIME $DATE "
