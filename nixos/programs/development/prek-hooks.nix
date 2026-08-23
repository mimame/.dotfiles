# ----------------------------------------------------------------------------
# Pre-commit Hooks (prek)
#
# Tools required for prek hooks: formatters, linters, and secret scanners.
# These are installed system-wide for convenience, but CI uses shell.nix.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    # Core
    prek # Fast pre-commit hook manager

    # Formatters
    go # Go toolchain (includes gofmt)
    jaq # jq clone in Rust (for editor settings)
    jsonfmt # JSON formatter
    nixfmt # Nix code formatter
    stylua # Lua code formatter
    taplo # TOML formatter
    yamlfmt # YAML formatter

    # Linters
    actionlint # GitHub Actions workflow linter
    commitlint # Conventional commit message linter
    golangci-lint # Go comprehensive linter
    statix # Nix linter and anti-pattern finder

    # Security
    gitleaks # Secret scanner with service-specific rules
    ripsecrets # Fast secret scanner for high-entropy strings
  ];
}
