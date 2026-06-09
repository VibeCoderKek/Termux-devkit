#!/usr/bin/env bash

set -e

echo "checking dependencies..."
for cmd in tmux nvim jq fzf git zsh; do
	if ! command -v "$cmd" &>/dev/null; then
		echo "missing: $cmd — run: pkg install $cmd"
		exit 1
	fi
done
echo "dependencies ok"

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

mkdir -p ~/.config/nvim/lua
mkdir -p ~/bin

ln -sf "$DOTFILES/nvim/init.lua" ~/.config/nvim/init.lua
ln -sf "$DOTFILES/nvim/lua/proj.lua" ~/.config/nvim/lua/proj.lua

ln -sf "$DOTFILES/bin/proj" ~/bin/proj

ln -sf "$DOTFILES/shell/.zshrc" ~/.zshrc
ln -sf "$DOTFILES/shell/.tmux.conf" ~/.tmux.conf

chmod +x ~/bin/proj

echo "proj installed."
