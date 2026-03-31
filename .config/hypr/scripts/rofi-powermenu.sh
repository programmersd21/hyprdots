#!/usr/bin/env bash
chosen=$(printf "  Power Off\n󰑐  Restart\n󰤄  Suspend\n󰍃  Log Out\n  Lock" | rofi -dmenu -i -p "Power" -theme ~/.config/rofi/powermenu.rasi)
case "$chosen" in
    "  Power Off") systemctl poweroff ;;
    "󰑐  Restart")  systemctl reboot ;;
    "󰤄  Suspend")  systemctl suspend ;;
    "󰍃  Log Out")  hyprctl dispatch exit ;;
    "  Lock")     loginctl lock-session ;;
esac
