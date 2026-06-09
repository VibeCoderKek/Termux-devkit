#!/bin/zsh
# ─────────────────────────────────────────────
#  proj / enter.sh  —  vaporwave IDE greeter
#  runs automatically on: cd ~/projects/proj
# ─────────────────────────────────────────────

# ANSI vaporwave palette (matches Muse vapeHue)
MAG='\e[38;5;165m' # magenta  ~300°
CYN='\e[38;5;51m'  # cyan     ~190°
PNK='\e[38;5;213m' # pink     ~330°
PUR='\e[38;5;135m' # purple   ~270°
DIM='\e[38;5;240m' # dim grey
RST='\e[0m'
BLD='\e[1m'

clear

# ── Banner ─────────────────────────────────────
# Try toilet first (supports ANSI art), fall back to figlet, then raw echo
if command -v toilet &>/dev/null; then
	toilet -f future --filter border PROJ 2>/dev/null |
		sed "s/.*/${MAG}&${RST}/"
elif command -v figlet &>/dev/null; then
	figlet -f slant PROJ |
		sed "s/.*/${MAG}${BLD}&${RST}/"
else
	echo -e "${MAG}${BLD}"
	echo "  ██████╗ ██████╗  ██████╗      ██╗"
	echo "  ██╔══██╗██╔══██╗██╔═══██╗     ██║"
	echo "  ██████╔╝██████╔╝██║   ██║     ██║"
	echo "  ██╔═══╝ ██╔══██╗██║   ██║██   ██║"
	echo "  ██║     ██║  ██║╚██████╔╝╚█████╔╝"
	echo "  ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚════╝ "
	echo -e "${RST}"
fi

# ── Git info ───────────────────────────────────
if git rev-parse --git-dir &>/dev/null; then
  BRANCH=$(git branch --show-current 2>/dev/null)
  REMOTE=$(git remote get-url origin 2>/dev/null | sed 's|https://github.com/||')
  LAST_MSG=$(git log --oneline -1 2>/dev/null | cut -c9-)
  LAST_HASH=$(git log --oneline -1 2>/dev/null | cut -c1-7)
  CHANGES=$(git status --short 2>/dev/null | wc -l | tr -d ' ')
  STAGED=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  AHEAD=$(git rev-list @{u}..HEAD 2>/dev/null | wc -l | tr -d ' ')

  echo -e "${DIM}  ╔══════════════════════════════════════════╗${RST}"
  echo -e "  ${DIM}║${RST}  ${CYN}branch${RST}      ${MAG}${BRANCH}${RST}"
  echo -e "  ${DIM}║${RST}  ${CYN}remote${RST}      ${DIM}${REMOTE}${RST}"
  echo -e "  ${DIM}║${RST}  ${CYN}last${RST}        ${PNK}${LAST_MSG}${RST} ${DIM}(${LAST_HASH})${RST}"
  echo -e "  ${DIM}║${RST}  ${CYN}status${RST}      ${CHANGES} changed  ${STAGED} staged  ${AHEAD} ahead"
  echo -e "${DIM}  ╚══════════════════════════════════════════╝${RST}"
else
  echo -e "  ${DIM}(not a git repo)${RST}"
fi

echo ""
