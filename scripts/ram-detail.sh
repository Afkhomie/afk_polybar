#!/bin/bash
# RAM detail popup - right click on ram module

read total_kb _ < <(grep MemTotal /proc/meminfo | awk '{print $2}')
read avail_kb _ < <(grep MemAvailable /proc/meminfo | awk '{print $2}')
used_kb=$(( total_kb - avail_kb ))

fmt_smart() {
  local kb=$1
  if [ "$kb" -ge 1048576 ]; then
    awk "BEGIN {printf \"%.2f GB\", $kb/1048576}"
  else
    awk "BEGIN {printf \"%.0f MB\", $kb/1024}"
  fi
}

CURRENT=$(fmt_smart $used_kb)
TOTAL=$(fmt_smart $total_kb)

# Track max usage
MAX_FILE="/tmp/polybar_ram_max"
MAX_KB=$(cat "$MAX_FILE" 2>/dev/null || echo "$used_kb")
[ "$used_kb" -gt "$MAX_KB" ] && MAX_KB=$used_kb && echo $MAX_KB > "$MAX_FILE"
MAX=$(fmt_smart $MAX_KB)

# Sparkline (4 samples)
GRAPH=""
for i in $(seq 1 4); do
  s_used=$(( $(grep MemTotal /proc/meminfo | awk '{print $2}') - $(grep MemAvailable /proc/meminfo | awk '{print $2}') ))
  pct=$(awk "BEGIN {printf \"%d\", ($s_used/$total_kb)*100}")
  if   [ $pct -ge 80 ]; then GRAPH="${GRAPH}▇"
  elif [ $pct -ge 60 ]; then GRAPH="${GRAPH}▅"
  elif [ $pct -ge 40 ]; then GRAPH="${GRAPH}▃"
  elif [ $pct -ge 20 ]; then GRAPH="${GRAPH}▂"
  else GRAPH="${GRAPH}▁"
  fi
  sleep 0.3
done

# Top RAM process
TOP_PROC=$(ps -eo pmem,comm --sort=-%mem 2>/dev/null | awk 'NR==2 {printf "%s (%.1f%%)", $2, $1}')

BODY="Current: ${CURRENT} / ${TOTAL}\nMax (since boot): ${MAX}"
[ -n "$GRAPH" ] && BODY="${BODY}\nUsage:  ${GRAPH}"
BODY="${BODY}\nTop process: ${TOP_PROC}"

notify-send "RAM Usage" "$BODY" -t 5000 -u low
