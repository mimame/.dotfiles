# This module defines packages for Lua development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    lua51Packages.jsregexp # JavaScript regular expressions for Lua
    lua51Packages.lua # Lua interpreter
    lua51Packages.luarocks # Lua package manager (for Neovim)
    lua-language-server # Language server for Lua
    stylua # Lua formatter
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
#     lua51Packages.jsregexp
#     lua51Packages.lua
#     lua51Packages.luarocks
#     lua-language-server
#     stylua
#   ];
# }
# ---------------------------------------------------------------------------
