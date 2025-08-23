#!/bin/bash

choice=$(echo -e "Lock\nLogout\nReboot\nShutdown" | rofi -dmenu -p "")

case "$choice" in
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
