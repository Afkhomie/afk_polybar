#!/bin/bash
# FA6: f538 = memory chip
icon=$(printf '\uf538')
used_kb=$(free | awk '/^Mem:/{print $3}')
if [ "$used_kb" -ge 1048576 ]; then
  val=$(awk "BEGIN {printf \"%.1f\", $used_kb/1048576}")
  echo "${icon} ${val}GB"
else
  val=$(awk "BEGIN {printf \"%.0f\", $used_kb/1024}")
  echo "${icon} ${val}MB"
fi
