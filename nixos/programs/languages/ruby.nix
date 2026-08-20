# This module defines packages for Ruby development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    ruby # The Ruby programming language (default interpreter)
  ];
}

# ---------------------------------------------------------------------------
# Per-project shell.nix (reference — LSPs/linters not installed system-wide).
# The default interpreter stays system-wide. Copy into a project as shell.nix:
#
# Pick a channel for pkgs:
#   stable:   { pkgs ? import <nixpkgs> { } }:
#   unstable: { pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") { } }:
# pkgs.mkShell {
#   packages = with pkgs; [
#     ruby-lsp
#     rubocop
#     rubyPackages.erb-formatter
#   ];
# }
# ---------------------------------------------------------------------------
