#!/usr/bin/env bash
STATE_FILE="$HOME/.cache/hyprdots/wf-recorder.file"
mkdir -p "$(dirname "$STATE_FILE")"

if pgrep -x wf-recorder > /dev/null; then
    killall -SIGINT wf-recorder
    if [ -f "$STATE_FILE" ]; then
        FILE="$(cat "$STATE_FILE")"
        rm -f "$STATE_FILE"
        notify-send "Screen Recording" "Saved to $FILE"
    else
        notify-send "Screen Recording" "Recording stopped"
    fi
else
    FILE="$HOME/Videos/Recordings/$(date +%Y-%m-%d_%H-%M-%S).mp4"
    echo "$FILE" > "$STATE_FILE"
    notify-send "Screen Recording" "Select area to record"
    wf-recorder -g "$(slurp)" -f "$FILE" &
fi
