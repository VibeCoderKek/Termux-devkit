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

pcd() { cd "$(proj cd "$@")"; }
alias copygame="find ~/projects/testapp/h4ck -type f | sort | while read f; do echo \"=== \$f ===\"; cat \"\$f\"; echo; done | termux-clipboard-set"
