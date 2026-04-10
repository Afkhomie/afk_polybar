#!/bin/bash
# Net detail popup - right click on net module
iface=$(ip route | grep default | awk '{print $5}' | head -1)
[ -z "$iface" ] && notify-send "Network" "No interface found" -t 4000 && exit

rx1=$(cat /sys/class/net/$iface/statistics/rx_bytes)
tx1=$(cat /sys/class/net/$iface/statistics/tx_bytes)
sleep 1
rx2=$(cat /sys/class/net/$iface/statistics/rx_bytes)
tx2=$(cat /sys/class/net/$iface/statistics/tx_bytes)

rx_kb=$(( ($rx2 - $rx1) / 1024 ))
tx_kb=$(( ($tx2 - $tx1) / 1024 ))

fmt_speed() {
  local kb=$1
  if [ "$kb" -ge 1024 ]; then
    awk "BEGIN {printf \"%.2f MB/s\", $kb/1024}"
  else
    echo "${kb} KB/s"
  fi
}

rx_str=$(fmt_speed $rx_kb)
tx_str=$(fmt_speed $tx_kb)

SSID=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep "^yes" | cut -d: -f2)
SECURITY=$(nmcli -t -f active,security dev wifi 2>/dev/null | grep "^yes" | cut -d: -f2)
[ -z "$SSID" ] && SSID="Wired / Unknown"
[ -z "$SECURITY" ] && SECURITY="N/A"

TYPE=$(nmcli -t -f type,state dev 2>/dev/null | grep ":connected" | head -1 | cut -d: -f1)

notify-send "Network" "Download: $rx_str\nUpload:   $tx_str\n\nSSID: $SSID\nSecurity: $SECURITY\nInterface: $iface" \
  -t 5000 -u low
