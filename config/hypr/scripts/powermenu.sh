#!/bin/bash

CONFIG_DIR="$HOME/.config/hypr"
MAIN_CONFIG="$CONFIG_DIR/hyprland.conf"
PERFORMANCE_CONFIG="$CONFIG_DIR/hyprland-performance.conf"
POWERSAVE_CONFIG="$CONFIG_DIR/hyprland-powersave.conf"

choice=$(echo -e "power-saving\nperformance\nlock\nlogout\nreboot\nshutdown" | rofi -dmenu -p "")

case "$choice" in
"power-saving")
  ln -sf "$POWERSAVE_CONFIG" "$MAIN_CONFIG"
  dunstify -u normal -t 5000 "Switched to Power-saving mode!" "Please logout and log back in to apply changes."
  ;;
"performance")
  ln -sf "$PERFORMANCE_CONFIG" "$MAIN_CONFIG"
  dunstify -u normal -t 5000 "Switched to Performance mode!" "Please logout and log back in to apply changes."
  ;;
"lock")
  hyprlock
  ;;
"logout")
  hyprctl dispatch exit
  ;;
"reboot")
  shutdown -r now
  ;;
"shutdown")
  shutdown -h now
  ;;
*)
  exit 1
  ;;
esac
