#!/bin/bash
# Disk detail popup - right click on disk module

BODY=""
while IFS= read -r line; do
  src=$(echo "$line" | awk '{print $1}')
  size_b=$(echo "$line" | awk '{print $2}')
  used_b=$(echo "$line" | awk '{print $3}')
  mnt=$(echo "$line" | awk '{print $4}')

  used_gb=$(awk "BEGIN {printf \"%.2f\", $used_b/1073741824}")
  size_gb=$(awk "BEGIN {printf \"%.2f\", $size_b/1073741824}")
  pct=$(awk "BEGIN {printf \"%d\", ($used_b/$size_b)*100}")

  # Bar: 20 chars wide
  filled=$(awk "BEGIN {printf \"%d\", ($used_b/$size_b)*20}")
  bar=""
  for ((i=0; i<filled; i++)); do bar="${bar}█"; done
  for ((i=filled; i<20; i++)); do bar="${bar}░"; done

  BODY="${BODY}${src} (${mnt})\n${bar} ${pct}%\n${used_gb}GB / ${size_gb}GB\n\n"
done < <(df -B1 --output=source,size,used,target | grep "^/dev" | grep -v "tmpfs\|loop\|udev")

notify-send "Disk Usage" "$BODY" -t 6000 -u low
