# This module defines packages for AsciiDoc processing.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    asciidoc-full # AsciiDoc processor
    asciidoctor # AsciiDoc processor written in Ruby
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
#     asciidoc-full
#     asciidoctor
#   ];
# }
# ---------------------------------------------------------------------------
