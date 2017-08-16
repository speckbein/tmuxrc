#!/bin/bash

smux_bat_bar=("⣀" "⣤" "⣶" "⣿")
smux_bat_colors=("red" "yellow" "yellow" "green")
smux_bat_color_black="colour8"
smux_bat_step=(0 25 50 75)

smux_bat_charging_glyph="▲"
smux_bat_discharging_glyph="▼"

if [ "$(pmset -g batt | grep -o 'AC Power')" ]; then
    smux_bat_connected=1
    smux_bat_glyph=$smux_bat_charging_glyph
else
    smux_bat_connected=0
    smux_bat_glyph=$smux_bat_discharging_glyph
fi

smux_bat_pct=$(pmset -g batt | grep -o '[0-9]*%' | tr -d %)
smux_bat_remain=$(pmset -g batt |grep -o ' [0-9]*:[0-9]* ' |tr -d ' ')

smux_bat_status_color=$smux_bat_color_black
smux_bat_status=""

for i in "${!smux_bat_bar[@]}"; do
  if [ $smux_bat_pct -ge ${smux_bat_step[$i]} ]; then
    smux_bat_status_color=${smux_bat_colors[$i]}
    smux_tmp_color=${smux_bat_colors[$i]}
  else
    smux_tmp_color=$smux_bat_color_black
  fi
    smux_bat_status="$smux_bat_status#[fg=$smux_tmp_color]${smux_bat_bar[$i]}"
done
if [ -n $smux_bat_remain ]; then
    smux_bat_remain=" $smux_bat_remain "
fi

if [[ $smux_bat_pct -eq 100 && $smux_bat_connected == 1 ]]; then
  smux_bat_extra=""
else
  smux_bat_extra=" #[fg=$smux_bat_color_black][#[fg=$smux_bat_status_color]$smux_bat_pct%$smux_bat_remain$smux_bat_glyph#[fg=$smux_bat_color_black]]"
fi

echo -n "$smux_bat_status$smux_bat_extra#[fg=default,bg=default,none]"

