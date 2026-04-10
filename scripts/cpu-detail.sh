#!/bin/bash
# CPU detail popup - right click on cpu module

CURRENT=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2)}')

# Track max usage via temp file
MAX_FILE="/tmp/polybar_cpu_max"
if [ -f "$MAX_FILE" ]; then
  MAX=$(cat "$MAX_FILE")
else
  MAX=0
fi
if [ "$CURRENT" -gt "$MAX" ]; then
  MAX=$CURRENT
  echo $MAX > "$MAX_FILE"
fi

# Uptime
UP_SECS=$(awk '{print int($1)}' /proc/uptime)
DAYS=$(( UP_SECS / 86400 ))
HOURS=$(( (UP_SECS % 86400) / 3600 ))
MINS=$(( (UP_SECS % 3600) / 60 ))
SECS=$(( UP_SECS % 60 ))
if [ "$DAYS" -gt 0 ]; then
  UPTIME=$(printf "%dd:%02d:%02d:%02d" $DAYS $HOURS $MINS $SECS)
else
  UPTIME=$(printf "%02d:%02d:%02d" $HOURS $MINS $SECS)
fi

# Sparkline from /proc/stat samples (5 samples, 0.2s apart)
SAMPLES=()
for i in $(seq 1 5); do
  read -r _ u n s id _ < /proc/stat
  total=$(( u + n + s + id ))
  idle=$id
  SAMPLES+=("$total:$idle")
  sleep 0.2
done

GRAPH=""
PREV_TOTAL=0; PREV_IDLE=0
for sample in "${SAMPLES[@]}"; do
  t=$(echo $sample | cut -d: -f1)
  i=$(echo $sample | cut -d: -f2)
  if [ $PREV_TOTAL -gt 0 ]; then
    dt=$(( t - PREV_TOTAL ))
    di=$(( i - PREV_IDLE ))
    pct=$(awk "BEGIN {printf \"%d\", (1 - $di/$dt)*100}")
    if   [ $pct -ge 80 ]; then GRAPH="${GRAPH}▇"
    elif [ $pct -ge 60 ]; then GRAPH="${GRAPH}▅"
    elif [ $pct -ge 40 ]; then GRAPH="${GRAPH}▃"
    elif [ $pct -ge 20 ]; then GRAPH="${GRAPH}▂"
    else GRAPH="${GRAPH}▁"
    fi
  fi
  PREV_TOTAL=$t; PREV_IDLE=$i
done

BODY="Current: ${CURRENT}%\nMax (since boot): ${MAX}%\nUptime: ${UPTIME}"
[ -n "$GRAPH" ] && BODY="${BODY}\nUsage: ${GRAPH}"

notify-send "CPU Usage" "$BODY" -t 5000 -u low
