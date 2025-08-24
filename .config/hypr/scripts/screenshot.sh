#!/bin/bash

if [ "$1" == "screen" ]; then
  FILENAME=$HOME/Pictures/Screenshot_full_$(date +%Y-%m-%d_%H-%M-%S).png
  grimblast copysave screen -o "$FILENAME"
  if [ $? -eq 0 ]; then
    dunstify -u normal -t 5000 "Fullscreen screenshot saved!" "$FILENAME"
  else
    dunstify -u critical -t 5000 "Screenshot Error" "Failed to capture the entire screen."
  fi
elif [ "$1" == "area" ]; then
  FILENAME=$HOME/Pictures/Screenshot_area_$(date +%Y-%m-%d_%H-%M-%S).png
  grimblast copysave area -o "$FILENAME"
  if [ $? -eq 0 ]; then
    dunstify -u normal -t 5000 "Area screenshot saved!" "$FILENAME"
  else
    dunstify -u critical -t 5000 "Screenshot Error" "Failed to capture the selected screen area."
  fi
else
  dunstify -u critical -t 5000 "Error" "Please provide a valid argument: 'screen' or 'area'."
fi
