-- =========================================================
-- CORE OPTIONS
-- =========================================================

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400
vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = " "

-- =========================================================
-- LAZY.NVIM BOOTSTRAP
-- =========================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- =========================================================
-- PLUGINS
-- =========================================================

require("lazy").setup({
  spec = {
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },

    {
      "nvim-tree/nvim-tree.lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    { "lewis6991/gitsigns.nvim" },

    {
      "neovim/nvim-lspconfig",
      config = function()
        require("lspconfig")
      end,
    },

    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
    {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    {
      "folke/tokyonight.nvim",
      priority = 1000,
      config = function()
        require("tokyonight").setup({
          style = "night",
          transparent = false,
          terminal_colors = true,
        })
        vim.cmd("colorscheme tokyonight")
      end,
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lualine").setup({
          options = {
            theme = "tokyonight",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
          },
          sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { { "filename", path = 1 } },
            lualine_x = { "encoding", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
          },
        })
      end,
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      config = function()
        local wk = require("which-key")
        wk.setup({
          delay = 400,
          icons = { rules = false },
        })
        wk.add({
          { "<leader>e",  desc = "Toggle file tree" },
          { "<leader>f",  desc = "Find files" },
          { "<leader>g",  desc = "Live grep" },
          { "<leader>b",  desc = "Buffers" },
          { "<leader>w",  desc = "Save file" },
          { "<leader>q",  desc = "Quit" },
          { "<leader>h",  desc = "Clear search highlight" },
          { "<leader>rn", desc = "LSP rename" },
          { "<leader>gg", desc = "Lazygit" },
          { "<leader>xx", desc = "Trouble diagnostics" },
          { "gd",         desc = "LSP go to definition" },
          { "K",          desc = "LSP hover" },
        })
      end,
    },
    {
      "kdheepak/lazygit.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Lazygit" })
      end,
    },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        local autopairs = require("nvim-autopairs")
        autopairs.setup({ check_ts = true })
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
    },
    {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end,
    },
    {
      "stevearc/conform.nvim",
      config = function()
        require("conform").setup({
          formatters_by_ft = {
            javascript  = { "prettier" },
            typescript  = { "prettier" },
            html        = { "prettier" },
            css         = { "prettier" },
            json        = { "prettier" },
            python      = { "black" },
            sh          = { "shfmt" },
            lua         = { "stylua" },
          },
          format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
          },
        })
      end,
    },
    {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("trouble").setup()
        vim.keymap.set("n", "<leader>xx", ":Trouble diagnostics toggle<CR>", { desc = "Trouble diagnostics" })
      end,
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      config = function()
        require("ibl").setup({
          indent = { char = "│" },
          scope  = { enabled = true },
        })
      end,
    },
  },
})

-- =========================================================
-- FILE TREE
-- =========================================================

require("nvim-tree").setup({
  view = { width = 35 },
  git = { enable = true },
})

-- =========================================================
-- GITSIGNS
-- =========================================================

require("gitsigns").setup()

-- =========================================================
-- CMP (AUTOCOMPLETE)
-- =========================================================

local luasnip = require("luasnip")
local cmp = require("cmp")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
})

-- =========================================================
-- LSP (MODERN API)
-- =========================================================

local servers = {
  "pyright",
  "ts_ls",
  "html",
  "cssls",
  "bashls",
}

for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    capabilities = capabilities,
  })
end

vim.lsp.enable(servers)

-- =========================================================
-- KEYMAPS
-- =========================================================

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>g", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>b", ":Telescope buffers<CR>")

vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)

-- =========================================================
-- PROJ WORKSPACE INTEGRATION
-- =========================================================

require('proj')
