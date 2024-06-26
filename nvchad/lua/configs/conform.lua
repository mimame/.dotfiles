local options = {
  formatters_by_ft = {
    bash = { "shfmt" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "biome" },
    json = { "biome" },
    latex = { "latexindent" },
    lua = { "stylua" },
    python = { "ruff" },
    ruby = { "rubocop" },
    typescript = { "biome" },
    tyspt = { "typstfmt" },
    yaml = { "rubocop" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

require("conform").setup(options)
