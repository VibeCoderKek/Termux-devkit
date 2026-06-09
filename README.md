# proj

A lightweight terminal-first development environment for Android powered by Termux, Neovim, tmux, fzf, and Git.

**Version:** 2.1.0

---

## What it does

proj is a workspace manager that makes multiple development projects feel organized and persistent from a mobile terminal. Each workspace is a named JSON record that tracks your project path, type, git branch, dev command, and last opened timestamp. Opening a workspace spins up a tmux session with dedicated windows for your editor, server, and shell — and restores exactly where you left off.

---

## Requirements

- Termux
- tmux
- nvim
- jq
- fzf
- git
- zsh

Optional (for language-specific features):
- Node.js, Python, Rust, Go

---

## Installation

```sh
git clone https://github.com/VibeCoderKek/proj.git
cd proj
bash install.sh
```

The installer symlinks:

- `nvim/init.lua` → `~/.config/nvim/init.lua`
- `nvim/lua/proj.lua` → `~/.config/nvim/lua/proj.lua`
- `bin/proj` → `~/bin/proj`
- `shell/.zshrc` → `~/.zshrc`
- `shell/.tmux.conf` → `~/.tmux.conf`

---

## Usage

```
proj                      Interactive project picker
proj open   [name]        Open workspace
proj switch               Switch workspace (from inside tmux)
proj cd     [name]        Print workspace path
proj add    [path] [name] Register a project
proj list                 List all workspaces
proj status [name]        Runtime status
proj kill   [name]        Kill workspace session
proj delete [name]        Unregister a workspace
proj rename <old> <new>   Rename a workspace
proj server restart <name>
proj server status  [name]
proj session list
proj session clear  <name>
proj init   [path]        Scan directory and register all projects
proj update [name]        Refresh branch and type metadata
proj sync   [name]        Pull latest for all workspaces (skips dirty)
proj log    [n] [follow|-f]  View last n log lines (default 50), or follow
proj log    [n] grep <term>  Grep log for term
proj dashboard            Live workspace overview
proj doctor               Check dependencies
proj help                 Full command reference
```

### Jumping into a workspace

Add `pcd` to your shell for seamless directory switching:

```sh
pcd myproject
```

This is included in `shell/.zshrc` automatically.

---

## Workspace management

### Registering a project

```sh
proj add ~/projects/myapp
proj add ~/projects/myapp myapp-name
```

proj auto-detects project type and dev command from common files.

### Project type detection

| Type    | Detection files                              |
|---------|----------------------------------------------|
| Node    | package.json                                 |
| Python  | pyproject.toml, setup.py, requirements.txt   |
| Rust    | Cargo.toml                                   |
| Go      | go.mod                                       |
| Web     | index.html                                   |
| Lua     | init.lua                                     |
| Generic | fallback                                     |

### Bulk registration

```sh
proj init                  # scans ~/projects/
proj init ~/work           # scans a custom path
PROJ_SCAN_DIR=~/work proj init  # via env var
```

### Keeping metadata fresh

```sh
proj update          # refresh branch + type for all workspaces
proj update myapp    # single workspace
```

---

## Git integration

`proj list` shows branch with a `*` suffix when the working tree is dirty:

```
myapp    main*    Python    2h ago
```

### Bulk sync

```sh
proj sync         # git pull --ff-only on all clean workspaces
proj sync myapp   # single workspace
```

Dirty workspaces are skipped automatically to protect uncommitted work.

---

## Layout system

Each project type has a layout file in `~/.proj/layouts/` that controls tmux window structure. Layouts are created automatically on first open.

Example `~/.proj/layouts/node.conf`:

```
windows=nvim,server,shell
server_cmd=npm run dev
```

Example `~/.proj/layouts/rust.conf`:

```
windows=nvim,build,shell
server_cmd=cargo run
```

Edit these files to customize the window layout for any project type.

---

## Dashboard

```sh
proj dashboard
```

Opens a live workspace overview that auto-refreshes every 3 seconds. Shows name, type, branch, dirty status, live/idle, and last opened time.

Keys: `q` quit · `o` open workspace · `r` refresh

From inside tmux, press `prefix + P` to open the dashboard as a popup overlay.

---

## Session persistence

Neovim sessions are saved automatically on exit and restored on next open via `mksession`. Sessions are stored per-workspace in `~/.proj/sessions/`.

Available Neovim commands:

```
:ProjSave       Save current session manually
:ProjRestore    Restore session manually
:ProjSwitch     Switch workspace via fzf
```

---

## Logging

```sh
proj log              # last 50 log entries
proj log 100          # last 100 entries
proj log 50 follow    # live tail
proj log 50 grep lsp  # filtered
```

Log file lives at `~/.proj/logs/proj.log`.

---

## Repository structure

```
proj/
├── bin/
│   └── proj              # workspace manager CLI
├── nvim/
│   ├── init.lua          # Neovim config (lazy.nvim, LSP, plugins)
│   └── lua/
│       └── proj.lua      # session save/restore, PID tracking
├── shell/
│   ├── .tmux.conf        # tmux config with proj keybindings
│   └── .zshrc            # aliases, pcd wrapper
└── install.sh
```

---

## Neovim plugins

| Plugin | Purpose |
|--------|---------|
| lazy.nvim | Plugin manager |
| Treesitter | Syntax highlighting |
| Telescope | Fuzzy finding |
| nvim-tree | File explorer |
| nvim-lspconfig | LSP |
| nvim-cmp + LuaSnip | Completion |
| Gitsigns | Git decorations |
| Lualine | Status line |
| Which Key | Keymap hints |
| LazyGit | Git UI |
| conform.nvim | Auto formatting |
| Trouble | Diagnostics |
| indent-blankline | Indent guides |
| nvim-autopairs | Auto pairs |
| Comment.nvim | Comment toggling |

Theme: Tokyo Night

---

## Design philosophy

- Terminal-first, mobile-friendly
- Minimal dependencies
- Workspace persistence across reboots
- Git-centric workflows
- Fast project switching
- Local-first — no cloud, no daemons

---

## License

MIT

