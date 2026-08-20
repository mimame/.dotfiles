# This module defines packages for Go development.
{
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    go # Go programming language compiler and tools
    golangci-lint # A fast Go linters aggregator
    gopls # Go language server
    delve # Debugger for the Go programming language
    impl # Generate method stubs for implementing an interface
    gomodifytags # Go tool to modify struct field tags
    gofumpt # Enforce a stricter format than gofmt
    (lib.lowPrio gotools) # Additional Go tools, including goimports
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
#     go
#     golangci-lint
#     gopls
#     delve
#     impl
#     gomodifytags
#     gofumpt
#     gotools
#   ];
# }
# ---------------------------------------------------------------------------
