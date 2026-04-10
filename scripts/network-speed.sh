#!/bin/bash
iface=$(ip route | grep default | awk '{print $5}' | head -1)
if [ -z "$iface" ]; then echo "no net"; exit; fi

rx1=$(cat /sys/class/net/$iface/statistics/rx_bytes)
tx1=$(cat /sys/class/net/$iface/statistics/tx_bytes)
sleep 1
rx2=$(cat /sys/class/net/$iface/statistics/rx_bytes)
tx2=$(cat /sys/class/net/$iface/statistics/tx_bytes)

rx_kb=$(( ($rx2 - $rx1) / 1024 ))
tx_kb=$(( ($tx2 - $tx1) / 1024 ))

DOWN=$(printf '\uf063')
UP=$(printf '\uf062')

fmt_speed() {
  local kb=$1
  if [ "$kb" -ge 1024 ]; then
    awk "BEGIN {printf \"%.1fMB\", $kb/1024}"
  else
    echo "${kb}KB"
  fi
}

rx_str=$(fmt_speed $rx_kb)
tx_str=$(fmt_speed $tx_kb)

echo "%{T2}${DOWN}%{T-}${rx_str}  %{T2}${UP}%{T-}${tx_str}"
