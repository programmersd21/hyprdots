#!/usr/bin/env bash
DIR="$HOME/wallpapers"
WP=$(find "$DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) | shuf -n 1)
~/.config/hypr/scripts/wallpaper-set.sh "$WP"
