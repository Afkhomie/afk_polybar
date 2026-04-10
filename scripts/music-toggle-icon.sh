#!/bin/bash
STATUS=$(playerctl status 2>/dev/null)
[ -z "$STATUS" ] || [ "$STATUS" = "No players found" ] && exit 0
[ "$STATUS" = "Playing" ] && printf '\uf28b' || printf '\uf144'
