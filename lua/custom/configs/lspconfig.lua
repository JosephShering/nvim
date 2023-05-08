local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local util = require "lspconfig/util";

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "clangd", "rust-analyzer"}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.gopls.setup = {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = {"go", "gomod", "gowork", "gotmpl"},
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      }
    }
  }
}

lspconfig.elixirls.setup = {
  on_attach = function(client, bufnr)
    local map_opts = { buffer = true, noremap = true}

    -- run the codelens under the cursor
    vim.keymap.set("n", "<space>r",  vim.lsp.codelens.run, map_opts)
    -- remove the pipe operator
    vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", map_opts)
    -- add the pipe operator
    vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", map_opts)
    vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", map_opts)

    -- bindings for standard LSP functions.
    vim.keymap.set("n", "<space>df", "<cmd>lua vim.lsp.buf.format()<cr>", map_opts)
    vim.keymap.set("n", "<space>gd", "<cmd>lua vim.diagnostic.open_float()<cr>", map_opts)
    vim.keymap.set("n", "<space>dt", "<cmd>lua vim.lsp.buf.definition()<cr>", map_opts)
    vim.keymap.set("n", "<space>K", "<cmd>lua vim.lsp.buf.hover()<cr>", map_opts)
    vim.keymap.set("n", "<space>gD","<cmd>lua vim.lsp.buf.implementation()<cr>", map_opts)
    vim.keymap.set("n", "<space>1gD","<cmd>lua vim.lsp.buf.type_definition()<cr>", map_opts)
    -- keybinds for fzf-lsp.nvim: https://github.com/gfanto/fzf-lsp.nvim
    -- you could also use telescope.nvim: https://github.com/nvim-telescope/telescope.nvim
    -- there are also core vim.lsp functions that put the same data in the loclist
    vim.keymap.set("n", "<space>gr", ":References<cr>", map_opts)
    vim.keymap.set("n", "<space>g0", ":DocumentSymbols<cr>", map_opts)
    vim.keymap.set("n", "<space>gW", ":WorkspaceSymbols<cr>", map_opts)
    vim.keymap.set("n", "<leader>d", ":Diagnostics<cr>", map_opts)
  end,
  capabilities = capabilities,
  root_dir = util.root_pattern(".elixirls")
}

-- 
-- lspconfig.pyright.setup { blabla}
