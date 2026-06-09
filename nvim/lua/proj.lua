-- =============================================================================
-- lua/proj.lua  —  proj workspace integration for Neovim
-- =============================================================================

local M = {}

local session_dir = vim.fn.expand("~/.proj/sessions")
local run_dir     = vim.fn.expand("~/.proj/run")

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

local function get_workspace_name()
  local name = vim.env.PROJ_WORKSPACE
  if name and name ~= "" then return name end

  local session = vim.fn.system("tmux display-message -p '#S' 2>/dev/null"):gsub("\n", "")
  if session:match("^proj%-") then
    return session:sub(6)
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
  vim.fn.mkdir(session_dir, "p")

  local name = get_workspace_name()
  if not name then return end

  local sf = session_file(name)

  local ok, nvim_tree = pcall(require, "nvim-tree.api")
  if ok then nvim_tree.tree.close() end

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
    if vim.fn.argc() == 0 then
      vim.cmd("silent! source " .. vim.fn.fnameescape(sf))
      vim.notify("[proj] Session restored: " .. name, vim.log.levels.INFO)
    end
  end
end

-- ---------------------------------------------------------------------------
-- Autocommands
-- ---------------------------------------------------------------------------

local function setup_autocmds()
  local group = vim.api.nvim_create_augroup("ProjWorkspace", { clear = true })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group    = group,
    callback = M.save_session,
    desc     = "[proj] Auto-save nvim session on exit",
  })

  vim.api.nvim_create_autocmd("VimEnter", {
    group    = group,
    nested   = true,
    once     = true,
    callback = M.restore_session,
    desc     = "[proj] Auto-restore nvim session on enter",
  })

  vim.api.nvim_create_autocmd("VimEnter", {
    group    = group,
    once     = true,
    callback = function()
      local name = get_workspace_name()
      if not name then return end
      local pid  = tostring(vim.fn.getpid())
      local lock = run_dir .. "/" .. name .. ".lock"
      if vim.fn.filereadable(lock) == 1 then
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
    vim.cmd("terminal proj switch")
  end, { desc = "Switch proj workspace via fzf" })
end

-- ---------------------------------------------------------------------------
-- Setup
-- ---------------------------------------------------------------------------

function M.setup(opts)
  opts = opts or {}
  vim.fn.mkdir(session_dir, "p")
  setup_autocmds()
  setup_commands()
end

M.setup()

return M
