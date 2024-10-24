local options = {
  formatters_by_ft = {
    bash = { "shfmt" },
    crystal = { "crystal" },
    css = { "prettier" },
    fish = { "fish_indent" },
    go = { "gofmt" },
    html = { "prettier" },
    javascript = { "biome" },
    json = { "biome" },
    latex = { "latexindent" },
    lua = { "stylua" },
    nim = { "nimpretty" },
    nix = { "nixfmt" },
    python = { "ruff_format" },
    ruby = { "rubocop" },
    rust = { "rustfmt" },
    terraform = { "terraform_fmt" },
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
