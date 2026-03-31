#!/usr/bin/env bash
if [ "$1" == "up" ]; then
    brightnessctl s +5%
elif [ "$1" == "down" ]; then
    brightnessctl s 5%-
fi
