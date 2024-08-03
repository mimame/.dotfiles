local options = {
  formatters_by_ft = {
    bash = { "shfmt" },
    css = { "prettier" },
    fish = { "fish_indent" },
    html = { "prettier" },
    javascript = { "biome" },
    json = { "biome" },
    latex = { "latexindent" },
    lua = { "stylua" },
    nix = { "nixfmt" },
    python = { "ruff" },
    ruby = { "rubocop" },
    toml = { "taplo" },
    typescript = { "biome" },
    tyspt = { "typstyle" },
    yaml = { "rubocop" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

require("conform").setup(options)
