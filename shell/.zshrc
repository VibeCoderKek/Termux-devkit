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

# ═══════════════════════════════════════════════════════════
#  PROJ IDE  —  .zshrc additions
#  Paste this block at the bottom of your ~/.zshrc
#  Then: source ~/.zshrc
# ═══════════════════════════════════════════════════════════

# ── Vaporwave prompt ──────────────────────────────────────
# %F{165} = magenta  %F{51} = cyan  %F{213} = pink
# Shows: ~/path  branch  ❯
_git_branch() {
  local b
  b=$(git branch --show-current 2>/dev/null)
  [[ -n "$b" ]] && echo " %F{135}⎇ ${b}%f"
}

_git_dirty() {
  local s
  s=$(git status --short 2>/dev/null)
  [[ -n "$s" ]] && echo " %F{213}✦%f"
}


# ── Aliases (extend your existing set) ───────────────────
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gst='git stash'
alias gd='git diff --cached'          # staged diff
alias gun='git restore --staged .'    # unstage all

# gc-smart: path depends on where you put the script
alias gcai='~/projects/proj/gc-smart'

# ── Auto-greeter on cd into proj ─────────────────────────
function chpwd() {
  local PROJ_PATH="$HOME/projects/proj"
  if [[ "$PWD" == "$PROJ_PATH" ]] && [[ -f "$PROJ_PATH/enter.sh" ]]; then
    source "$PROJ_PATH/enter.sh"
  fi
}

# ── Clipboard helpers ────────────────────────────────────
# copy last command to clipboard
alias clc='fc -ln -1 | tr -d "\n" | termux-clipboard-set && echo "copied"'
# copy a file's content
cfile() { cat "$1" | termux-clipboard-set && echo "copied: $1" }
# copy current path
alias cpwd='echo -n "$PWD" | termux-clipboard-set && echo "copied: $PWD"'
# Fire greeter if starting session inside proj
[[ "$PWD" == "$HOME/projects/proj" ]] && source "$HOME/projects/proj/enter.sh"
# ── nvim paste-safe open ─────────────────────────────────
# Opens nvim and immediately enters paste mode (your standard workflow)
vp() {
  nvim -c 'set paste' "${1:-.}"
}

# ── Termux package check: install toilet + figlet if absent ──
if ! command -v toilet &>/dev/null && ! command -v figlet &>/dev/null; then
  echo "tip: pkg install toilet figlet  for vaporwave banner"
fi

# ═══════════════════════════════════════════════════════════

alias cprojekt="cat src/types/index.ts src/constants/theme.ts src/constants/data.ts src/utils/dateHelpers.ts src/utils/xpHelpers.ts src/storage/storage.ts src/hooks/useStorage.ts src/hooks/useXP.ts src/components/TabBar.tsx src/components/QuestCard.tsx src/components/AddQuestModal.tsx src/components/AddGuildModal.tsx src/screens/QuestsScreen.tsx src/screens/GuildsScreen.tsx src/screens/CharacterScreen.tsx src/app/_layout.tsx \"src/app/(tabs)/_layout.tsx\" \"src/app/(tabs)/index.tsx\" | termux-clipboard-set"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

alias vector-snapshot='termux-clipboard-set "$(git branch --show-current; echo ''; git log --oneline -5; echo ''; echo '=== PROJECT SNAPSHOT ==='; find . -maxdepth 3 -type f | sort; echo ''; echo '=== RESUME PROMPT ==='; echo 'Continue Vector from current GitFlow checkpoint. Maintain feature isolation.'; echo ''; echo '=== PRODUCT DIRECTION ==='; echo 'Professional-first, LeetCode-inspired. Editor is the hero. Not game-like.'; echo ''; echo '=== DESIGN PLAN ==='; echo 'Phase 1: Color system - replace yellow CTAs with neutral primary (touches every screen)'; echo 'Phase 2: Success modal - no emoji/Nice work, replace with pass/fail + runtime stats'; echo 'Phase 3: Editor UX - CodeMirror/WebView upgrade, keyboard toolbar, bracket matching'; echo 'Phase 4: Lock states - remove emoji padlocks, greyed text + subtle icon only'; echo 'Phase 5: Module lists - information-dense, difficulty tags, acceptance rate'; echo 'Phase 6: Onboarding - remove XP/Roles gamification slide, lead with curriculum'; echo ''; echo '=== CURRENT FOCUS ==='; echo 'Phase 1: CTA color system overhaul';)"'
