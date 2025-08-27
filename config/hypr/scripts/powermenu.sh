#!/bin/bash

CONFIG_DIR="$HOME/.config/hypr"
MAIN_CONFIG="$CONFIG_DIR/hyprland.conf"
PERFORMANCE_CONFIG="$CONFIG_DIR/hyprland-performance.conf"
POWERSAVE_CONFIG="$CONFIG_DIR/hyprland-powersave.conf"

choice=$(echo -e "Power-saving\nPerformance\nLock\nLogout\nReboot\nShutdown" | rofi -dmenu -p "")

case "$choice" in
"Power-saving")
  ln -sf "$POWERSAVE_CONFIG" "$MAIN_CONFIG"
  dunstify -u normal -t 5000 "Switched to Power-saving mode!" "Please logout and log back in to apply changes."
  ;;
"Performance")
  ln -sf "$PERFORMANCE_CONFIG" "$MAIN_CONFIG"
  dunstify -u normal -t 5000 "Switched to Performance mode!" "Please logout and log back in to apply changes."
  ;;
"Lock")
  hyprlock
  ;;
"Logout")
  hyprctl dispatch exit
  ;;
"Reboot")
  shutdown -r now
  ;;
"Shutdown")
  shutdown -h now
  ;;
*)
  exit 1
  ;;
esac
