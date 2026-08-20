# This module defines packages for Python development and tooling.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    python3 # Python 3 interpreter (required by tmux plugins like extrakto)
    uv # A fast Python package installer and resolver
    # python3Packages.ptpython # Advanced Python REPL
    # python3Packages.ipython # Powerful interactive Python shell
    # ruff # An extremely fast Python linter
    # pyright # Static type checker for Python
    # ty # Fast Python type checker (alternative to pyright)
    # python3Packages.debugpy # An implementation of the Debug Adapter Protocol for Python
  ];
}

# ---------------------------------------------------------------------------
# Per-project shell.nix (reference — LSPs/linters not installed system-wide).
# uv manages per-project Python versions (.python-version), so the interpreter
# and uv stay system-wide. Copy into a project as shell.nix:
#
# Pick a channel for pkgs:
#   stable:   { pkgs ? import <nixpkgs> { } }:
#   unstable: { pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") { } }:
# pkgs.mkShell {
#   packages = with pkgs; [
#     uv
#     python3Packages.ptpython
#     python3Packages.ipython
#     ruff
#     pyright
#     python3Packages.debugpy
#   ];
# }
# ---------------------------------------------------------------------------
