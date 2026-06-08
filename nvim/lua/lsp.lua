-- Modern Neovim LSP config (0.11+)

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- connect nvim-cmp to LSP (safe even if cmp missing)
local ok, cmp = pcall(require, "cmp_nvim_lsp")
if ok then
  capabilities = cmp.default_capabilities(capabilities)
end

-- Server configs (modern API)
vim.lsp.config("pyright", {
  capabilities = capabilities,
})

vim.lsp.config("ts_ls", {
  capabilities = capabilities,
})

vim.lsp.config("html", {
  capabilities = capabilities,
})

vim.lsp.config("cssls", {
  capabilities = capabilities,
})

vim.lsp.config("bashls", {
  capabilities = capabilities,
})

-- enable servers
vim.lsp.enable({
  "pyright",
  "ts_ls",
  "html",
  "cssls",
  "bashls",
})
