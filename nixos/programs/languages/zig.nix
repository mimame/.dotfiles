# This module defines packages for Zig development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    zig # The Zig programming language
    zls # Zig Language Server
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
#     zig
#     zls
#   ];
# }
# ---------------------------------------------------------------------------
