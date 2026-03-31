#!/usr/bin/env bash
DIR="$HOME/wallpapers"
SELECTED=$(ls "$DIR" | rofi -dmenu -i -p "󰸉 Wallpapers" -theme ~/.config/rofi/wallpaper.rasi)
if [ -n "$SELECTED" ]; then
    ~/.config/hypr/scripts/wallpaper-set.sh "$DIR/$SELECTED"
fi
