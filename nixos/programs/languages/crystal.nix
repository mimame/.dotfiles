# This module defines packages for Crystal development.
# crystal + shards stay system-wide: build dependency of the tmux-fingers plugin.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    crystal # The Crystal programming language
    shards # Dependency manager for Crystal
  ];
}

# ---------------------------------------------------------------------------
# Per-project shell.nix (reference — full toolchain for portability).
# crystal + shards are also system-wide (tmux-fingers build dependency), but
# keep them here so the shell works on any NixOS without a system-wide install.
# Copy into a project as shell.nix and use direnv `use nix`:
#
# Pick a channel for pkgs:
#   stable:   { pkgs ? import <nixpkgs> { } }:
#   unstable: { pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") { } }:
# pkgs.mkShell {
#   packages = with pkgs; [
#     crystal
#     shards
#     ameba
#     ameba-ls
#     crystalline
#   ];
# }
# ---------------------------------------------------------------------------
