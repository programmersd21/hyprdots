#!/usr/bin/env bash
# rofi-keybinds.sh
# Parses every bind/bindm line from ~/.config/hypr/configs/*.conf,
# formats them into a searchable cheat-sheet in rofi.
# Selecting an entry copies the keybind combo to the clipboard.

CONF_DIR="$HOME/.config/hypr/configs"

# ── pretty dispatcher labels ──────────────────────────────────────────────────
label_dispatcher() {
    local d="$1" a="$2"
    case "$d" in
        exec)               echo "$a" ;;
        killactive)         echo "Kill focused window" ;;
        exit)               echo "Exit Hyprland" ;;
        togglefloating)     echo "Toggle floating" ;;
        fullscreen)         echo "Toggle fullscreen" ;;
        pseudo)             echo "Toggle pseudo-tile" ;;
        togglesplit)        echo "Toggle split direction" ;;
        movefocus)          echo "Focus → $a" ;;
        workspace)          echo "Switch to workspace $a" ;;
        movetoworkspace)    echo "Move window → workspace $a" ;;
        movewindow)         echo "Move window (mouse)" ;;
        resizewindow)       echo "Resize window (mouse)" ;;
        *)                  [ -n "$a" ] && echo "$d $a" || echo "$d" ;;
    esac
}

# ── section name from comment ─────────────────────────────────────────────────
section_from_comment() {
    # Matches:  # ── applications ──
    [[ "$1" =~ ^#[[:space:]]*──[[:space:]]+([^─]+)[[:space:]]*─ ]] && \
        printf "%s" "${BASH_REMATCH[1]}" | sed 's/[[:space:]]*$//'
}

# ── build entry list ──────────────────────────────────────────────────────────
build_entries() {
    local current_section=""

    for f in $(ls "$CONF_DIR"/*.conf 2>/dev/null | sort); do
        while IFS= read -r line; do
            # Detect section header comments
            local sec
            sec=$(section_from_comment "$line")
            if [ -n "$sec" ]; then
                current_section="$sec"
                continue
            fi

            # Skip blank lines and plain comments
            [[ -z "${line//[[:space:]]/}" ]] && continue
            [[ "$line" =~ ^[[:space:]]*# ]]  && continue

            # Match:  bind[m|e|l]? = MOD, KEY, DISPATCHER [, ARGS...]
            if [[ "$line" =~ ^[[:space:]]*bind[mel]?[[:space:]]*=[[:space:]]*(.*) ]]; then
                local rest="${BASH_REMATCH[1]}"
                IFS=',' read -ra parts <<< "$rest"

                local mod="${parts[0]//[[:space:]]/}"
                local key="${parts[1]//[[:space:]]/}"
                local disp="${parts[2]//[[:space:]]/}"
                # args = everything after dispatcher, rejoined
                local args=""
                if [ "${#parts[@]}" -gt 3 ]; then
                    args="${parts[*]:3}"
                    args="${args#"${args%%[![:space:]]*}"}"  # ltrim
                    args="${args%"${args##*[![:space:]]}"}"  # rtrim
                fi

                # Substitute variable names
                mod="${mod/\$mainMod/Super}"
                key="${key/\$mainMod/Super}"

                # Build combo string
                local combo
                if [ -n "$mod" ]; then
                    combo="$mod + $key"
                else
                    combo="$key"
                fi

                local action
                action=$(label_dispatcher "$disp" "$args")

                # Shorten script paths for readability
                action="${action//$HOME\/.config\/hypr\/scripts\//}"
                action="${action//.sh/}"

                local section_label=""
                [ -n "$current_section" ] && section_label="[$current_section]"

                printf "%-38s  %-36s  %s\n" "$combo" "$action" "$section_label"
            fi
        done < "$f"
    done
}

# ── launch rofi ───────────────────────────────────────────────────────────────
chosen=$(build_entries | rofi \
    -dmenu \
    -i \
    -p "⌨  Keybinds" \
    -theme ~/.config/rofi/keybinds.rasi \
    -no-custom \
    -mesg "Search keybindings  •  Enter: copy combo to clipboard")

[ -z "$chosen" ] && exit 0

# Copy just the combo (first field) to clipboard
combo=$(echo "$chosen" | awk '{print $1, $2, $3}' | sed 's/[[:space:]]*$//')
echo -n "$combo" | wl-copy
notify-send "Keybind copied" "$combo" -t 2000 -i keyboard
