#!/bin/bash

# Only show battery if it exists
if [ ! -f "/sys/class/power_supply/BAT0/capacity" ]; then
    exit 1
fi

capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)

if [ -z "$capacity" ]; then
    exit 1
fi

echo "$capacity%"
