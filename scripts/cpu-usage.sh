#!/bin/bash
# FA6 f0e4 = dashboard/gauge - actual FA6 Free Solid glyph
cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2)}')
icon=$(printf '\uf0e4')
echo "${icon} ${cpu}%"
