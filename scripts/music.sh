#!/bin/bash
# Returns empty = module hidden, returns text = module visible
case "$1" in
  play-pause) playerctl play-pause; exit ;;
  next)       playerctl next; exit ;;
  prev)       playerctl previous; exit ;;
esac

STATUS=$(playerctl status 2>/dev/null)
[ -z "$STATUS" ] || [ "$STATUS" = "No players found" ] && exit 0

TITLE=$(playerctl metadata title 2>/dev/null)
ARTIST=$(playerctl metadata artist 2>/dev/null)
[ -z "$TITLE" ] && exit 0

NOTE=$(printf '\uf001')
TEXT="${ARTIST:+$ARTIST - }${TITLE}"
MARQUEE_WIDTH=20
TEXT_LEN=${#TEXT}

if [ "$TEXT_LEN" -le "$MARQUEE_WIDTH" ]; then
  echo "%{T2}${NOTE}%{T-} ${TEXT}"
  exit 0
fi

STATE_FILE="/tmp/polybar_music_scroll"
OFFSET=0
[ -f "$STATE_FILE" ] && OFFSET=$(cat "$STATE_FILE" 2>/dev/null || echo 0)
PADDED="${TEXT}   "
PADDED_LEN=${#PADDED}
DISPLAY="${PADDED:$OFFSET:$MARQUEE_WIDTH}"
[ "${#DISPLAY}" -lt "$MARQUEE_WIDTH" ] && DISPLAY="${DISPLAY}${PADDED:0:$(( MARQUEE_WIDTH - ${#DISPLAY} ))}"
echo "%{T2}${NOTE}%{T-} ${DISPLAY}"
echo $(( (OFFSET + 2) % PADDED_LEN )) > "$STATE_FILE"
