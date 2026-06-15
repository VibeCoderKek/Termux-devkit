eval "$(starship init zsh)"
alias ls='eza --icons'
alias ll='eza -la --icons'
alias cat='bat'
alias gs='git status'
alias v='nvim'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gst='git status'
export PATH="$HOME/scripts:$PATH"

source $PREFIX/share/fzf/key-bindings.zsh 2>/dev/null

export PATH=$PREFIX/bin:$PATH
export PATH="$HOME/bin:$PATH"

# proj cd wrapper — jump directly into a workspace
pcd() {
  local path
  path="$(proj cd "$@")" || return 1
  cd "$path"
}

# Start ollama silently in background
ollama serve > /dev/null 2>&1 &

# PROJ startup banner
cat << 'BANNER'

  ██████╗ ██████╗  ██████╗      ██╗
  ██╔══██╗██╔══██╗██╔═══██╗     ██║
  ██████╔╝██████╔╝██║   ██║     ██║
  ██╔═══╝ ██╔══██╗██║   ██║██   ██║
  ██║     ██║  ██║╚██████╔╝╚█████╔╝
  ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚════╝

BANNER
proj list
