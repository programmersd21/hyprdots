#!/usr/bin/env bash
# wallpaper-picker.sh
# Rofi wallpaper selector with live thumbnail previews.
#
# Dependencies: rofi-wayland, imagemagick (convert), find
# Thumbnails are cached in ~/.cache/hyprdots/thumbs/ and only regenerated
# when the source image is newer than the cached thumbnail.

WALLPAPER_DIR="$HOME/wallpapers"
CACHE_DIR="$HOME/.cache/hyprdots/thumbs"
THUMB_SIZE="256x256"

mkdir -p "$CACHE_DIR"

# ── build rofi entries ────────────────────────────────────────────────────────
# rofi extended-dmenu format:
#   display_name NUL "icon" US /path/to/thumb NEWLINE
# where NUL = \0 (ASCII 0) and US = \x1f (ASCII 31)

build_entries() {
    while IFS= read -r -d '' img; do
        name=$(basename "$img")
        thumb="$CACHE_DIR/${name%.*}.thumb.png"

        # Regenerate thumbnail only if missing or stale
        if [ ! -f "$thumb" ] || [ "$img" -nt "$thumb" ]; then
            convert "$img" \
                -thumbnail "${THUMB_SIZE}^" \
                -gravity Center \
                -extent "$THUMB_SIZE" \
                "$thumb" 2>/dev/null || {
                # Fallback: copy raw if convert fails (e.g. unusual format)
                cp "$img" "$thumb" 2>/dev/null
            }
        fi

        # Output rofi extended-dmenu entry
        printf "%s\0icon\x1f%s\n" "$name" "$thumb"
    done < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \
           -o -iname '*.gif' -o -iname '*.webp' -o -iname '*.bmp' \) \
        -print0 | sort -z)
}

# ── launch rofi ──────────────────────────────────────────────────────────────
selected=$(build_entries | rofi \
    -dmenu \
    -i \
    -p "󰸉  Wallpaper" \
    -theme ~/.config/hypr/rofi/wallpaper-picker.rasi \
    -show-icons \
    -icon-size 72 \
    -eh 2)

# ── apply ────────────────────────────────────────────────────────────────────
if [ -n "$selected" ]; then
    "$HOME/.config/hypr/scripts/wallpaper-set.sh" "$WALLPAPER_DIR/$selected"
fi
