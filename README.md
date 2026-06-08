# Termux DevKit

A lightweight terminal-first development environment for Android powered by Termux, Neovim, tmux, fzf, and Git.

Termux DevKit provides:

- Workspace management
- Project session persistence
- tmux integration
- Neovim IDE configuration
- Git-aware project tracking
- Fast project switching
- Terminal-focused development workflows

The centerpiece of the project is `proj`, a workspace manager designed to make multiple development projects feel organized and persistent from a mobile terminal.

---

## Features

### Workspace Management

Create and manage project workspaces from a single interface.

Each workspace stores metadata such as:

- Project name
- Path
- Project type
- Development command
- Git branch
- Last opened timestamp

Supported project detection:

- Node.js
- Python
- Rust
- Go
- Lua
- Static web projects
- Generic repositories

---

### Session Persistence

Neovim sessions are automatically saved and restored.

Features include:

- Automatic session save on exit
- Automatic restore on startup
- Per-workspace session files
- tmux session awareness
- Workspace-specific state tracking

This allows projects to reopen exactly where they were left.

---

### Git Integration

Workspaces automatically track:

- Current branch
- Repository status
- Dirty working trees

Git repositories are detected automatically.

---

### Project Type Detection

`proj` attempts to identify projects using common files:

| Type | Detection |
|--------|------------|
| Node | package.json |
| Python | pyproject.toml, setup.py, requirements.txt |
| Rust | Cargo.toml |
| Go | go.mod |
| Web | index.html |
| Lua | init.lua |

---

### Neovim IDE

Included Neovim configuration provides:

- lazy.nvim
- Treesitter
- Telescope
- Nvim Tree
- LSP support
- nvim-cmp completion
- LuaSnip
- Gitsigns
- Lualine
- Which Key
- LazyGit integration
- Auto formatting
- Trouble diagnostics
- Indent guides
- Automatic pair insertion
- Comment toggling

Theme:

- Tokyo Night

---

### tmux Integration

Designed around a tmux-first workflow.

Benefits include:

- Persistent terminals
- Workspace isolation
- Session management
- Fast project switching

---

## Repository Structure

```text
termux-devkit/
├── bin/
│   └── proj
├── nvim/
│   ├── init.lua
│   └── lua/
│       └── proj.lua
├── shell/
│   ├── .tmux.conf
│   └── .zshrc
└── install.sh
```

---

## Requirements

Recommended:

- Termux
- Git
- Neovim
- tmux
- jq
- fzf
- ripgrep
- Node.js (optional)
- Python (optional)
- Rust (optional)
- Go (optional)

---

## Installation

Clone the repository:

```bash
git clone https://github.com/VibeCoderKek/termux-devkit.git
cd termux-devkit
```

Run the installer:

```bash
bash install.sh
```

The installer creates symbolic links for:

- Neovim configuration
- proj workspace manager
- Zsh configuration
- tmux configuration

---

## Neovim Integration

The included `proj.lua` module integrates Neovim with workspace sessions.

Capabilities:

- Session save on exit
- Session restore on startup
- Workspace detection through tmux
- PID registration for workspace tracking

Available commands:

```vim
:ProjSave
:ProjRestore
:ProjSwitch
```

---

## Design Philosophy

Termux DevKit follows several principles:

- Terminal-first
- Fast startup
- Minimal dependencies
- Workspace persistence
- Git-centric workflows
- Mobile-friendly development
- Local-first tooling

The goal is to make Android + Termux feel like a practical software development workstation.

---

## Status

Active development.

The project currently focuses on:

- Workspace management
- Session persistence
- Neovim tooling
- Terminal productivity

Future enhancements may include:

- Improved workspace dashboards
- Better project templates
- Additional language support
- Enhanced session recovery
- Development environment bootstrapping

---

## License

MIT License
