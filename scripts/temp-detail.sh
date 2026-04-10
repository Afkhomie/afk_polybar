#!/bin/bash
# Temp detail popup - right click on temp module

get_temp() {
  local t
  t=$(sensors 2>/dev/null | awk '/Core 0/ {gsub("\\+|°C","",$3); print int($3)}')
  if [ -z "$t" ] || [ "$t" = "0" ]; then
    t=$(($(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo 0)/1000))
  fi
  echo "$t"
}

to_f() { awk "BEGIN {printf \"%.1f\", ($1 * 9/5) + 32}"; }
to_k() { awk "BEGIN {printf \"%.1f\", $1 + 273.15}"; }

CURRENT=$(get_temp)

# Track min/max/avg via temp files
MIN_FILE="/tmp/polybar_temp_min"
MAX_FILE="/tmp/polybar_temp_max"
SUM_FILE="/tmp/polybar_temp_sum"
CNT_FILE="/tmp/polybar_temp_cnt"

MIN=$(cat "$MIN_FILE" 2>/dev/null || echo "$CURRENT")
MAX=$(cat "$MAX_FILE" 2>/dev/null || echo "$CURRENT")
SUM=$(cat "$SUM_FILE" 2>/dev/null || echo "$CURRENT")
CNT=$(cat "$CNT_FILE" 2>/dev/null || echo 1)

[ "$CURRENT" -lt "$MIN" ] && MIN=$CURRENT && echo $MIN > "$MIN_FILE"
[ "$CURRENT" -gt "$MAX" ] && MAX=$CURRENT && echo $MAX > "$MAX_FILE"
SUM=$(( SUM + CURRENT )); CNT=$(( CNT + 1 ))
echo $SUM > "$SUM_FILE"; echo $CNT > "$CNT_FILE"
AVG=$(awk "BEGIN {printf \"%d\", $SUM/$CNT}")

# Sparkline (4 samples)
TEMPS=()
for i in $(seq 1 4); do TEMPS+=($(get_temp)); sleep 0.3; done
GRAPH=""
for t in "${TEMPS[@]}"; do
  if   [ $t -ge 80 ]; then GRAPH="${GRAPH}▇"
  elif [ $t -ge 65 ]; then GRAPH="${GRAPH}▅"
  elif [ $t -ge 50 ]; then GRAPH="${GRAPH}▃"
  elif [ $t -ge 35 ]; then GRAPH="${GRAPH}▂"
  else GRAPH="${GRAPH}▁"
  fi
done

fmt_triple() {
  local c=$1
  echo "${c}°C / $(to_f $c)°F / $(to_k $c)K"
}

BODY="Current: $(fmt_triple $CURRENT)\nMin:     $(fmt_triple $MIN)\nMax:     $(fmt_triple $MAX)\nAvg:     $(fmt_triple $AVG)"
[ -n "$GRAPH" ] && BODY="${BODY}\nTemp:    ${GRAPH}"

notify-send "CPU Temperature" "$BODY" -t 5000 -u low
