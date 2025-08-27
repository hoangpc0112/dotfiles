#!/bin/bash

WALLPAPER_DIR="$HOME/images/wallpapers"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"

[ -d "$WALLPAPER_DIR" ] || {
  dunstify -u critical -t 5000 "Wallpaper Error" "Wallpaper directory not found: $WALLPAPER_DIR"
  exit 1
}

cd "$WALLPAPER_DIR" || exit 1
IFS=$'\n'
SELECTED_WALL=$(for a in $(ls -t *.jpg *.png *.gif *.jpeg 2>/dev/null); do echo -en "$a\0icon\x1f$a\n"; done | rofi -dmenu -p "")
[ -z "$SELECTED_WALL" ] && exit 1
SELECTED_PATH="$WALLPAPER_DIR/$SELECTED_WALL"

{
  swww img --transition-type grow --transition-duration 1.5 --transition-fps 144 "$SELECTED_PATH"
  mkdir -p "$(dirname "$SYMLINK_PATH")"
  ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"
} >/dev/null 2>&1

if [ $? -ne 0 ]; then
  dunstify -u critical -t 5000 "Wallpaper Error" "An error occurred while changing the wallpaper."
  exit 1
fi

dunstify -u normal -t 5000 "Wallpaper changed!" "$SELECTED_WALL"
