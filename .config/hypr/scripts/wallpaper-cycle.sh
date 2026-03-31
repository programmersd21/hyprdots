#!/usr/bin/env bash
DIR="$HOME/wallpapers"
mapfile -t WALLPAPERS < <(find "$DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) | sort)

CURRENT=$(hyprctl hyprpaper listloaded | head -n 1)
NEXT_INDEX=0

for i in "${!WALLPAPERS[@]}"; do
    if [[ "${WALLPAPERS[$i]}" == "$CURRENT" ]]; then
        NEXT_INDEX=$(( (i + 1) % ${#WALLPAPERS[@]} ))
        break
    fi
done

~/.config/hypr/scripts/wallpaper-set.sh "${WALLPAPERS[$NEXT_INDEX]}"
