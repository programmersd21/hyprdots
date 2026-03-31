# Oh My Zsh (optional)
if [ -d "$HOME/.oh-my-zsh" ]; then
  export ZSH="$HOME/.oh-my-zsh"
  ZSH_THEME=""
  plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'
  source "$ZSH/oh-my-zsh.sh"
fi

# Starship prompt (preferred)
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

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
if command -v fastfetch >/dev/null 2>&1; then
  fastfetch --color-keys 4
fi
