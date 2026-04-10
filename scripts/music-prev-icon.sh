#!/bin/bash
# Returns FA6 step-backward only when player active
STATUS=$(playerctl status 2>/dev/null)
[ -z "$STATUS" ] || [ "$STATUS" = "No players found" ] && exit 0
printf '\uf048'
