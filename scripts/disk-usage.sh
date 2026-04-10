#!/bin/bash
# FA6: f0a0 = hdd
icon=$(printf '\uf0a0')
disk=$(df / | awk 'NR==2 {print $5}')
echo "${icon} ${disk}"
