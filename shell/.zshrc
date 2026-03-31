# Enable Starship Prompt
eval "$(starship init zsh)"

# Aliases
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'
alias update='sudo pacman -Syu'
alias v='nvim'

# Pywal colors
if [ -f ~/.cache/wal/sequences ]; then
    (cat ~/.cache/wal/sequences &)
fi

# Fastfetch on start
fastfetch --color-keys 4
