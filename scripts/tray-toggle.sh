#!/bin/bash
# Toggle system tray visibility via polybar IPC
STATE_FILE="/tmp/polybar_tray_state"

if [ ! -f "$STATE_FILE" ]; then
  echo "visible" > "$STATE_FILE"
fi

STATE=$(cat "$STATE_FILE")

if [ "$STATE" = "visible" ]; then
  polybar-msg action tray module_hide
  echo "hidden" > "$STATE_FILE"
else
  polybar-msg action tray module_show
  echo "visible" > "$STATE_FILE"
fi
