#!/usr/bin/env bash

if [ -z "$1" ]; then
    exit 1
fi

WALLPAPER="$1"

if ! pgrep -x hyprpaper > /dev/null; then
    hyprpaper &
    sleep 1
fi

hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$WALLPAPER"
for monitor in $(hyprctl monitors -j | jq -r '.[] | .name'); do
    hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER"
done

wal -q -i "$WALLPAPER" -n

mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
cp ~/.cache/wal/gtk.css ~/.config/gtk-3.0/gtk.css
cp ~/.cache/wal/gtk.css ~/.config/gtk-4.0/gtk.css

mkdir -p ~/.config/cava
cp ~/.cache/wal/cava.conf ~/.config/cava/config

mkdir -p ~/.config/waybar
if [ -f ~/.cache/wal/waybar.css ]; then
    cp ~/.cache/wal/waybar.css ~/.config/waybar/colors.css
fi

killall -SIGUSR2 waybar 2>/dev/null || true
killall -SIGUSR2 nwg-dock-hyprland 2>/dev/null || true
hyprctl reload
