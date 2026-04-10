#!/bin/bash
STATUS=$(playerctl status 2>/dev/null)
[ -z "$STATUS" ] || [ "$STATUS" = "No players found" ] && exit 0
printf ''
