#!/usr/bin/env bash
# clipboard-history.sh
# Clipboard history manager backed by cliphist.
#
# Enter         → decode entry, copy to clipboard, simulate Ctrl+V paste
# Alt+P         → pin / unpin selected entry
# Pinned items  → shown at the top with a 📌 prefix, always kept in history
#
# Dependencies: cliphist, wl-clipboard, wtype, libnotify

PINNED_FILE="$HOME/.local/share/hyprdots/pinned-clips"
mkdir -p "$(dirname "$PINNED_FILE")"
touch "$PINNED_FILE"

# ── helpers ───────────────────────────────────────────────────────────────────

# Decode a cliphist entry (handles both pinned and normal entries)
decode_entry() {
    local entry="$1"
    if [[ "$entry" == "📌  "* ]]; then
        # Pinned entry — strip prefix, content is inline
        printf '%s' "${entry#📌  }"
    else
        # Normal cliphist entry — decode via cliphist
        printf '%s' "$entry" | cliphist decode
    fi
}

# ── build entry list: pinned on top, then history ─────────────────────────────
build_entries() {
    # Pinned items (newest-first within pin file)
    while IFS= read -r line; do
        [ -n "$line" ] && printf '📌  %s\n' "$line"
    done < <(tac "$PINNED_FILE")

    # cliphist history (already newest-first)
    cliphist list 2>/dev/null
}

# ── launch rofi ───────────────────────────────────────────────────────────────
# -kb-custom-1 (Alt+p) → exit code 10 → pin/unpin action
chosen=$(build_entries | rofi \
    -dmenu \
    -i \
    -p "󰅇  Clipboard" \
    -theme ~/.config/hypr/rofi/clipboard.rasi \
    -kb-custom-1 "Alt+p" \
    -mesg "Enter: paste  •  Alt+P: pin / unpin")

exit_code=$?
[ -z "$chosen" ] && exit 0

# ── decode selected content ───────────────────────────────────────────────────
content=$(decode_entry "$chosen")

# ── handle exit code ──────────────────────────────────────────────────────────
if [ "$exit_code" -eq 0 ]; then
    # ── PASTE ────────────────────────────────────────────────────────────────
    printf '%s' "$content" | wl-copy

    # Simulate Ctrl+V in the previously focused window.
    # Small sleep lets wl-copy settle and rofi window close first.
    sleep 0.15
    wtype -M ctrl v -m ctrl 2>/dev/null || true

elif [ "$exit_code" -eq 10 ]; then
    # ── PIN / UNPIN ───────────────────────────────────────────────────────────
    if [[ "$chosen" == "📌  "* ]]; then
        # Already pinned → unpin
        escaped=$(printf '%s\n' "$content" | sed 's/[[\.*^$()+?{}|]/\\&/g')
        grep -v "^${escaped}$" "$PINNED_FILE" > "${PINNED_FILE}.tmp" \
            && mv "${PINNED_FILE}.tmp" "$PINNED_FILE"
        notify-send "Clipboard" "Unpinned entry" -t 1800 -i edit-delete
    else
        # Not pinned → pin (deduplicate)
        if ! grep -qxF "$content" "$PINNED_FILE" 2>/dev/null; then
            printf '%s\n' "$content" >> "$PINNED_FILE"
            notify-send "Clipboard" "Entry pinned 📌" -t 1800 -i bookmark-new
        else
            notify-send "Clipboard" "Already pinned" -t 1500 -i dialog-information
        fi
    fi
fi
