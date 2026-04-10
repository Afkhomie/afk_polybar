#!/bin/bash
# Windows module - app icon (FA6) + smart short name
declare -a windows

get_icon() {
  local title="$1"
  case "$title" in
    *Firefox*|*Mozilla*)       echo "%{T4}$(printf '\uf269')%{T-}" ;; # firefox brand font
    *Terminal*|*nischal_afk*)  echo "%{T2}$(printf '\uf120')%{T-}" ;; # terminal
    *Claude*|*claude*)         echo "%{T2}$(printf '\uf544')%{T-}" ;; # robot
    *VSCode*|*Code*|*Visual*)  echo "%{T2}$(printf '\uf121')%{T-}" ;; # code
    *Files*|*Caja*|*caja*)     echo "%{T2}$(printf '\uf07b')%{T-}" ;; # folder
    *VLC*)                     echo "%{T2}$(printf '\uf144')%{T-}" ;; # play
    *Spotify*)                 echo "%{T4}$(printf '\uf1bc')%{T-}" ;; # spotify brand font
    *Discord*)                 echo "%{T4}$(printf '\uf392')%{T-}" ;; # discord brand font
    *Steam*)                   echo "%{T4}$(printf '\uf1b6')%{T-}" ;; # steam brand font
    *)                         echo "%{T2}$(printf '\uf2d0')%{T-}" ;; # window
  esac
}

get_short() {
  local title="$1"
  case "$title" in
    *Firefox*|*Mozilla*)
      if   [[ "$title" =~ YouTube ]];  then echo "YouTube"
      elif [[ "$title" =~ Claude ]];   then echo "Claude"
      elif [[ "$title" =~ GitHub ]];   then echo "GitHub"
      elif [[ "$title" =~ SajhaStack ]]; then echo "SajhaStack"
      elif [[ "$title" =~ Gmail ]];    then echo "Gmail"
      else echo "Firefox"; fi ;;
    *Terminal*|*nischal_afk*|*bash*)   echo "Terminal" ;;
    *Claude*)                          echo "Claude" ;;
    *VSCode*|*Code*)                   echo "VSCode" ;;
    *Files*|*Caja*)                    echo "Files" ;;
    *VLC*)                             echo "VLC" ;;
    *)                                 echo "${title:0:14}" ;;
  esac
}

while IFS= read -r line; do
  win_id=$(echo "$line" | awk '{print $1}')
  title=$(echo "$line" | awk '{$1=$2=$3=""; print substr($0,4)}' | sed 's/^ *//')
  icon=$(get_icon "$title")
  short=$(get_short "$title")
  windows+=("%{A1:wmctrl -ia $win_id:}${icon} ${short}%{A}")
done < <(wmctrl -l | grep -v "polybar\|conky\|ulauncher\|Ulauncher\|Desktop\|Regulus")

output=""
for i in "${!windows[@]}"; do
  output="${output}${windows[$i]}"
  if [ $i -lt $((${#windows[@]} - 1)) ]; then
    output="${output}   "
  fi
done

echo "$output"
