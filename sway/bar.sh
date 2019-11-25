#!/bin/bash

TIME=$(date +'%k:%M')
DATE=$(date +'%d-%m-%Y')

BATTERY=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/percentage/{print $2}')

VOLUME=$(amixer sget Master | grep -oE "[0-9]{1,3}%" | head -n 1)

echo -e "🔉$VOLUME ⚡$BATTERY $TIME $DATE "
