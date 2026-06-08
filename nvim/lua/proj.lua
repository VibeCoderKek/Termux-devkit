-- =============================================================================
-- lua/proj.lua  —  proj workspace integration for Neovim
-- =============================================================================
-- Drop into your Neovim config at: ~/.config/nvim/lua/proj.lua
-- Then add to init.lua:  require('proj')
-- =============================================================================

local M = {}

local session_dir = vim.fn.expand("~/.proj/sessions")
local run_dir     = vim.fn.expand("~/.proj/run")

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

-- Derive the workspace name from the current tmux session name
-- tmux session is named "proj-<name>"; strip the prefix.
local function get_workspace_name()
  -- Try env var first (set by proj script)
  local name = vim.env.PROJ_WORKSPACE
  if name and name ~= "" then return name end

  -- Fall back to parsing the tmux session name
  local session = vim.fn.system("tmux display-message -p '#S' 2>/dev/null"):gsub("\n", "")
  if session:match("^proj%-") then
    return session:sub(6)  -- strip "proj-"
  end
  return nil
end

local function session_file(name)
  return session_dir .. "/" .. name .. ".vim"
end

-- ---------------------------------------------------------------------------
-- Session save
-- ---------------------------------------------------------------------------
function M.save_session()
  -- Ensure session dir exists
  vim.fn.mkdir(session_dir, "p")

  local name = get_workspace_name()
  if not name then return end

  local sf = session_file(name)

  -- Clean up before saving: close nvim-tree (it doesn't restore cleanly)
  local ok, nvim_tree = pcall(require, "nvim-tree.api")
  if ok then nvim_tree.tree.close() end

  -- mksession
  vim.cmd("mksession! " .. vim.fn.fnameescape(sf))
  vim.notify("[proj] Session saved: " .. name, vim.log.levels.INFO)
end

-- ---------------------------------------------------------------------------
-- Session restore
-- ---------------------------------------------------------------------------
function M.restore_session()
  local name = get_workspace_name()
  if not name then return end

  local sf = session_file(name)
  if vim.fn.filereadable(sf) == 1 then
    -- Source session only if we were called with no file args
    if vim.fn.argc() == 0 then
      vim.cmd("silent! source " .. vim.fn.fnameescape(sf))
      vim.notify("[proj] Session restored: " .. name, vim.log.levels.INFO)
    end
  else
    -- First time: open nvim-tree
    vim.schedule(function()
      local ok, _ = pcall(vim.cmd, "NvimTreeOpen")
      if not ok then
        pcall(vim.cmd, "Neotree show")  -- fallback to neo-tree
      end
    end)
  end
end

-- ---------------------------------------------------------------------------
-- Autocommands
-- ---------------------------------------------------------------------------
local function setup_autocmds()
  local group = vim.api.nvim_create_augroup("ProjWorkspace", { clear = true })

  -- Save session on exit
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group    = group,
    callback = M.save_session,
    desc     = "[proj] Auto-save nvim session on exit",
  })

  -- Restore session on startup (deferred so plugins are loaded first)
  vim.api.nvim_create_autocmd("VimEnter", {
    group    = group,
    nested   = true,
    once     = true,
    callback = M.restore_session,
    desc     = "[proj] Auto-restore nvim session on enter",
  })

  -- Update lock file with nvim PID so proj can track it
  vim.api.nvim_create_autocmd("VimEnter", {
    group    = group,
    once     = true,
    callback = function()
      local name = get_workspace_name()
      if not name then return end
      local pid  = tostring(vim.fn.getpid())
      local lock = run_dir .. "/" .. name .. ".lock"
      if vim.fn.filereadable(lock) == 1 then
        -- Update nvim_pid field in lock JSON via jq
        vim.fn.system(string.format(
          "jq --arg p %s '.nvim_pid = $p' %s > %s.tmp && mv %s.tmp %s",
          vim.fn.shellescape(pid),
          vim.fn.shellescape(lock),
          vim.fn.shellescape(lock),
          vim.fn.shellescape(lock),
          vim.fn.shellescape(lock)
        ))
      end
    end,
    desc = "[proj] Register nvim PID in workspace lock",
  })
end

-- ---------------------------------------------------------------------------
-- User commands
-- ---------------------------------------------------------------------------
local function setup_commands()
  vim.api.nvim_create_user_command("ProjSave",    M.save_session,    { desc = "Save proj workspace session" })
  vim.api.nvim_create_user_command("ProjRestore", M.restore_session, { desc = "Restore proj workspace session" })

  vim.api.nvim_create_user_command("ProjSwitch", function()
    -- Drop to shell and run proj switch (which uses fzf)
    vim.cmd("terminal proj switch")
  end, { desc = "Switch proj workspace via fzf" })
end

-- ---------------------------------------------------------------------------
-- Setup entry point
-- ---------------------------------------------------------------------------
function M.setup(opts)
  opts = opts or {}
  vim.fn.mkdir(session_dir, "p")
  setup_autocmds()
  setup_commands()
end

-- Auto-setup when required
M.setup()

return M

