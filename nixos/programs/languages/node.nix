# This module defines packages for Node.js development and tooling.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    nodejs # Node.js runtime
    yarn # Fast, reliable, and secure dependency management
    vscode-js-debug # JavaScript debugger
    vscode-langservers-extracted # HTML, CSS, JSON, ESLint LSPs
    typescript-language-server # TypeScript language server
    biome # Fast formatter and linter (Rust-based)
    vtsls # Faster TypeScript language server
  ];
}

# ---------------------------------------------------------------------------
# Per-project shell.nix (reference — toolchain not installed system-wide).
# Copy into a project as shell.nix and use direnv `use nix`:
#
# Pick a channel for pkgs:
#   stable:   { pkgs ? import <nixpkgs> { } }:
#   unstable: { pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") { } }:
# pkgs.mkShell {
#   packages = with pkgs; [
#     nodejs
#     yarn
#     vscode-js-debug
#     vscode-langservers-extracted
#     typescript-language-server
#     biome
#     vtsls
#   ];
# }
# ---------------------------------------------------------------------------
