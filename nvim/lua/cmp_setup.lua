local cmp = require("cmp")

cmp.setup({
  completion = {
    autocomplete = true,
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),

  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})
