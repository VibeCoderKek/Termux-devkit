#!/usr/bin/env bash
DOTFILES="$(cd "$(dirname "$0")" && pwd)"
mkdir -p ~/.config/nvim/lua ~/bin
ln -sf "$DOTFILES/nvim/init.lua"         ~/.config/nvim/init.lua
ln -sf "$DOTFILES/nvim/lua/proj.lua"     ~/.config/nvim/lua/proj.lua
ln -sf "$DOTFILES/nvim/lua/lsp.lua"      ~/.config/nvim/lua/lsp.lua
ln -sf "$DOTFILES/nvim/lua/cmp_setup.lua" ~/.config/nvim/lua/cmp_setup.lua
ln -sf "$DOTFILES/bin/proj"              ~/bin/proj
ln -sf "$DOTFILES/shell/.zshrc"          ~/.zshrc
ln -sf "$DOTFILES/shell/.tmux.conf"      ~/.tmux.conf
chmod +x ~/bin/proj
echo "Dotfiles installed."
