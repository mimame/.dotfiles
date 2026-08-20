# This module defines packages for Rust development and tooling.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    rustup # The Rust toolchain installer
    # lldb # A next-generation, high-performance debugger
    # vscode-extensions.vadimcn.vscode-lldb # VS Code CodeLLDB extension
  ];
}

# ---------------------------------------------------------------------------
# Per-project shell.nix (reference — toolchain not installed system-wide).
# rustup installs per-project toolchains, so only the installer is needed:
#
# Pick a channel for pkgs:
#   stable:   { pkgs ? import <nixpkgs> { } }:
#   unstable: { pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") { } }:
# pkgs.mkShell {
#   packages = with pkgs; [
#     rustup
#   ];
#   shellHook = ''
#     rustup default stable
#   '';
# }
# ---------------------------------------------------------------------------
