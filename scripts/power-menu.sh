#!/bin/bash
# Power menu - shutdown, restart, logout, sleep
LOCK="/tmp/polybar_power.lock"
[ -f "$LOCK" ] && exit 0
touch "$LOCK"
trap "rm -f $LOCK" EXIT

ICON=$(printf '\uf011')
OPTIONS="$ICON Shutdown\n$ICON Restart\n$ICON Logout\n$ICON Sleep"

SELECTION=$(echo -e "$OPTIONS" | rofi \
  -dmenu \
  -p "$(printf '\uf011') Power" \
  -theme-str 'window {width: 170px; location: north west; anchor: north west; x-offset: 4px; y-offset: 32px; border-radius: 10px; background-color: #252535; border: 0px;}' \
  -theme-str 'listview {lines: 4; spacing: 0px; background-color: #252535;}' \
  -theme-str 'element {padding: 10px 16px; background-color: #252535; text-color: #CDD6F4; border-radius: 6px;}' \
  -theme-str 'element selected {background-color: #F38BA8; text-color: #1E2030;}' \
  -theme-str 'inputbar {enabled: false;}' \
  -theme-str 'mainbox {padding: 4px;}' \
  -no-fixed-num-lines \
  -i)

[ -z "$SELECTION" ] && exit 0

case "$SELECTION" in
  *Shutdown*) systemctl poweroff ;;
  *Restart*)  systemctl reboot ;;
  *Logout*)   mate-session-save --logout ;;
  *Sleep*)    systemctl suspend ;;
esac
