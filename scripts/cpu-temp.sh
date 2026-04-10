#!/bin/bash
# FA6: f2c9 = thermometer
icon=$(printf '\uf2c9')
temp=$(sensors 2>/dev/null | awk '/Core 0/ {gsub("\\+|°C","",$3); print int($3)}')
if [ -z "$temp" ] || [ "$temp" = "0" ]; then
  temp=$(($(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo 0)/1000))
fi
[ -z "$temp" ] || [ "$temp" = "0" ] && echo "${icon} N/A" && exit
echo "${icon} ${temp}°C"
