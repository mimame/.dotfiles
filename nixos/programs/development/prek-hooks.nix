# ----------------------------------------------------------------------------
# Pre-commit Hooks (prek)
#
# System-wide installation of prek and its tool dependencies (formatters,
# linters, secret scanners) to accelerate dotfiles development workflow.
#
# Unlike shell.nix which requires `nix-shell` invocation per session, these
# tools are always available in PATH, eliminating shell startup overhead and
# enabling direct invocation from editors, git hooks, and CI pipelines.
#
# CI environments still use shell.nix for reproducibility and isolation.
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
