# This module defines packages for Elixir development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    beamPackages.elixir # The Elixir programming language
    beamPackages.elixir-ls # Elixir Language Server
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
#     beamPackages.elixir
#     beamPackages.elixir-ls
#   ];
# }
# ---------------------------------------------------------------------------
