#!/bin/zsh
MAG=$(printf '\033[38;5;165m')
CYN=$(printf '\033[38;5;51m')
PNK=$(printf '\033[38;5;213m')
DIM=$(printf '\033[38;5;240m')
RST=$(printf '\033[0m')
BLD=$(printf '\033[1m')

clear

if command -v toilet &>/dev/null; then
	printf "${MAG}${BLD}"
	toilet -f future --filter border PROJ
	printf "${RST}\n"
elif command -v figlet &>/dev/null; then
	printf "${MAG}${BLD}"
	figlet -f slant PROJ
	printf "${RST}\n"
else
	printf "${MAG}${BLD}\n"
	printf "  ██████╗ ██████╗  ██████╗      ██╗\n"
	printf "  ██╔══██╗██╔══██╗██╔═══██╗     ██║\n"
	printf "  ██████╔╝██████╔╝██║   ██║     ██║\n"
	printf "  ██╔═══╝ ██╔══██╗██║   ██║██   ██║\n"
	printf "  ██║     ██║  ██║╚██████╔╝╚█████╔╝\n"
	printf "  ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚════╝ \n"
	printf "${RST}\n"
fi

if git rev-parse --git-dir &>/dev/null; then
	BRANCH=$(git branch --show-current 2>/dev/null)
	REMOTE=$(git remote get-url origin 2>/dev/null | sed 's|https://github.com/||')
	LAST_MSG=$(git log --oneline -1 2>/dev/null | cut -c9-)
	LAST_HASH=$(git log --oneline -1 2>/dev/null | cut -c1-7)
	CHANGES=$(git status --short 2>/dev/null | wc -l | tr -d ' ')
	STAGED=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
	AHEAD=$(git rev-list @{u}..HEAD 2>/dev/null | wc -l | tr -d ' ')

	printf "${DIM}  ╔══════════════════════════════════════════╗${RST}\n"
	printf "  ${DIM}║${RST}  ${CYN}branch${RST}      ${MAG}${BRANCH}${RST}\n"
	printf "  ${DIM}║${RST}  ${CYN}remote${RST}      ${DIM}${REMOTE}${RST}\n"
	printf "  ${DIM}║${RST}  ${CYN}last${RST}        ${PNK}${LAST_MSG}${RST} ${DIM}(${LAST_HASH})${RST}\n"
	printf "  ${DIM}║${RST}  ${CYN}status${RST}      ${CHANGES} changed  ${STAGED} staged  ${AHEAD} ahead\n"
	printf "${DIM}  ╚══════════════════════════════════════════╝${RST}\n"
fi

printf "\n"
