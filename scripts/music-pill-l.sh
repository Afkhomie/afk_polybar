#!/bin/bash
# Returns pill char only when player active - auto-hides when nothing playing
STATUS=$(playerctl status 2>/dev/null)
[ -z "$STATUS" ] || [ "$STATUS" = "No players found" ] && exit 0
printf ''
