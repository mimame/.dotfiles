-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = {
  "ansiblels",
  "ast_grep",
  "autotools_ls",
  "awk_ls",
  "bashls",
  "biome",
  "bufls",
  "bzl",
  "crystalline",
  "cssls",
  "docker_compose_language_service",
  "dockerls", -- try to use hadolint instead
  "golangci_lint_ls",
  "graphql",
  "helm_ls",
  "html",
  "jsonls",
  "jsonnet_ls",
  "julials",
  "lua_ls",
  "marksman",
  "metals",
  "nil_ls",
  "nim_langserver",
  "nushell",
  "postgres_lsp",
  -- "pylyzer", -- not working by now
  "pyright",
  "rubocop",
  "ruby_ls",
  "ruff",
  "sqls",
  "svelte",
  "terraformls",
  "texlab",
  "tflint",
  -- "tinymist", -- use typst-lsp instead
  "typos_lsp",
  "typst_lsp",
  "yamlls",
  "zls",
}

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- typescript
-- lspconfig.tsserver.setup {
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
-- }
