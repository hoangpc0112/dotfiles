#!/bin/bash
echo " + K:Search all Keybinds
 + ENTER:Open terminal
 + Q:Close active window
 + E:Open file manager
 + B:Open web browser
 + F:Toggle floating mode
 + SHIFT + F:Toggle fullscreen mode
 + D:Open application launcher
 + V:Clipboard manager
 + PRINTSCREEN:Take screenshot (fullscreen)
PRINTSCREEN:Take screenshot (region)
 + W:Choose wallpaper
 + P:Open power menu
 + R:Toggle night light
 + C:Open code editor
 + 1-9:Change to workspace 1-9
 + SHIFT + 1-9:Move focused window to workspace 1-9
 + ARROWS_KEYS:Move focus
 + SHIFT + ARROWS_KEYS:Move window
 + LMB + DRAG:Drag window
 + RMB + DRAG:Resize window" | column -t -s ':' | rofi -dmenu -i -p ""
