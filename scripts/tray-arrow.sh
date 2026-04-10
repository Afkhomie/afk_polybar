#!/bin/bash
# Show correct arrow for tray toggle
STATE_FILE="/tmp/polybar_tray_state"
STATE=$(cat "$STATE_FILE" 2>/dev/null || echo "visible")
# FA6: chevron-left U+F053 = hidden, chevron-right U+F054 = visible (pointing to tray)
if [ "$STATE" = "visible" ]; then
  printf '\uf054'
else
  printf '\uf053'
fi
