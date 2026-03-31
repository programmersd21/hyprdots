#!/usr/bin/env bash
set -e

# Install AUR helper (yay) if not present
if ! command -v yay &> /dev/null; then
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd "$OLDPWD" && rm -rf /tmp/yay
fi

# System update and standard dependencies
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed \
    hyprland hyprpaper hypridle hyprlock \
    python-pywal waybar rofi-wayland kitty \
    starship cava cmatrix btop fzf fastfetch swaync \
    inter-font ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols \
    zsh neovim git curl wget jq bc wl-clipboard \
    grim slurp swappy brightnessctl playerctl \
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk polkit-kde-agent pamixer \
    wf-recorder libnotify imagemagick cliphist wtype networkmanager network-manager-applet bluez bluez-utils blueman

# Install AUR packages
yay -S --noconfirm --needed nwg-dock-hyprland rofi-bluetooth yazi-git oh-my-posh-bin

# Directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/wallpapers"
mkdir -p "$HOME/Videos/Recordings"
mkdir -p "$HOME/Pictures/Screenshots"

# Copy wallpapers
cp -rn wallpapers/* "$HOME/wallpapers/" 2>/dev/null || true

# Safe backup and copy function
backup_and_copy() {
    local src="$1"
    local dest="$2"
    if [ -d "$dest" ] || [ -f "$dest" ]; then
        mv "$dest" "${dest}.bak"
    fi
    cp -r "$src" "$dest"
}

# Safely copy all dotfiles from .config/
# gtk-3.0 and gtk-4.0 are inside .config/ so they are handled by the loop below —
# no separate backup_and_copy calls needed for them.
for dir in .config/*; do
    target="$HOME/.config/$(basename "$dir")"
    backup_and_copy "$dir" "$target"
done

backup_and_copy "mimeapps.list" "$HOME/.config/mimeapps.list"
backup_and_copy "shell/.zshrc"  "$HOME/.zshrc"
backup_and_copy "shell/.bashrc" "$HOME/.bashrc"
backup_and_copy "shell/.profile" "$HOME/.profile"

# Make scripts executable
find "$HOME/.config/hypr/scripts"        -type f -name "*.sh" -exec chmod +x {} \;
find "$HOME/.config/waybar/scripts" -type f -name "*.sh" -exec chmod +x {} \;

# Set up pywal and initial wallpaper
wal -i "$HOME/wallpapers/Green-Mast.png" -n
"$HOME/.config/hypr/scripts/wallpaper-set.sh" "$HOME/wallpapers/Green-Mast.png"

# Enable services
systemctl --user enable --now hypridle.service
sudo systemctl enable --now bluetooth.service

# Change default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
fi
