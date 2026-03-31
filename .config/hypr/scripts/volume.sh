#!/usr/bin/env bash
if [ "$1" == "up" ]; then
    pamixer -i 5
elif [ "$1" == "down" ]; then
    pamixer -d 5
elif [ "$1" == "mute" ]; then
    pamixer -t
fi
