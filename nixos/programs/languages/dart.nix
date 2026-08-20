# This module defines packages for Dart development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    flutter # Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase (includes Dart)
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
#     flutter
#   ];
# }
# ---------------------------------------------------------------------------
