#!/usr/bin/env bash
set -e

restore_or_remove() {
    local target="$1"
    if [ -d "${target}.bak" ] || [ -f "${target}.bak" ]; then
        rm -rf "$target"
        mv "${target}.bak" "$target"
    else
        rm -rf "$target"
    fi
}

restore_or_remove "$HOME/.config/hypr"
restore_or_remove "$HOME/.config/waybar"
restore_or_remove "$HOME/.config/rofi"
restore_or_remove "$HOME/.config/nwg-dock-hyprland"
restore_or_remove "$HOME/.config/wal"
restore_or_remove "$HOME/.config/kitty"
restore_or_remove "$HOME/.config/starship"
restore_or_remove "$HOME/.config/fastfetch"
restore_or_remove "$HOME/.config/swaync"
restore_or_remove "$HOME/.config/gtk-3.0"
restore_or_remove "$HOME/.config/gtk-4.0"
restore_or_remove "$HOME/.config/nvim"
restore_or_remove "$HOME/.config/cava"
restore_or_remove "$HOME/.config/mimeapps.list"
restore_or_remove "$HOME/.zshrc"
restore_or_remove "$HOME/.bashrc"
restore_or_remove "$HOME/.profile"
