#!/bin/bash

smux_loadavg_threshold=(0 1.6 2.0 2.7)
smux_loadavg_colors=("colour8" "green" "yellow" "red")
smux_threshold="0.1"
smux_loadavg=($(sysctl -q -n vm.loadavg | cut -d' ' -f2 -f3 -f4))

for i in "${!smux_loadavg_threshold[@]}"; do
  if (( $(echo "${smux_loadavg[1]} > ${smux_loadavg_threshold[$i]}" | bc -l) )); then
    smux_loadavg_color=${smux_loadavg_colors[$i]}
  fi
done
#smux_loadavg_glyph="◆"
smux_loadavg_glyph=""
if (( $(echo "${smux_loadavg[0]} > (${smux_loadavg[1]} + $smux_threshold )" | bc -l) )); then
  smux_loadavg_glyph="▲"
elif (( $(echo "${smux_loadavg[0]} < (${smux_loadavg[1]} - $smux_threshold )" | bc -l) )); then
  smux_loadavg_glyph="▼"
fi

if (( $(echo "${smux_loadavg[1]} < ${smux_loadavg_threshold[1]}" | bc -l) )); then
  smux_loadavg_glyph=""
fi

echo "#[fg=$smux_loadavg_color]${smux_loadavg[1]}$smux_loadavg_glyph#[fg=default,bg=default,none]"
