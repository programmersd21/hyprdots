# Oh My Zsh (optional)
if [ -d "$HOME/.oh-my-zsh" ]; then
  export ZSH="$HOME/.oh-my-zsh"
  ZSH_THEME=""
  plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'
  source "$ZSH/oh-my-zsh.sh"
fi

# Oh My Posh prompt (Catppuccin)
if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config catppuccin_mocha)"
elif command -v starship >/dev/null 2>&1; then
  # Fallback to Starship if Oh My Posh isn't available
  eval "$(starship init zsh)"
fi

# fzf defaults
if command -v fzf >/dev/null 2>&1; then
  if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  elif command -v rg >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git/*'"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="find . -type d -not -path '*/.git/*' 2>/dev/null"
  else
    export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/.git/*' 2>/dev/null"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="find . -type d -not -path '*/.git/*' 2>/dev/null"
  fi
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
fi

# fzf (keybindings + completion)
if command -v fzf >/dev/null 2>&1; then
  if [ -f /usr/share/fzf/key-bindings.zsh ]; then
    source /usr/share/fzf/key-bindings.zsh
  fi
  if [ -f /usr/share/fzf/completion.zsh ]; then
    source /usr/share/fzf/completion.zsh
  fi
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
