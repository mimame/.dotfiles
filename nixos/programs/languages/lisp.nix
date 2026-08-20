# This module defines packages for Lisp dialects.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    # Fennel (Lisp that compiles to Lua)
    fennel-ls # Language server for Fennel
    fnlfmt # Fennel formatter
    luajitPackages.fennel # Fennel compiler

    # Janet (functional and imperative programming language)
    janet # Janet language interpreter
    jpm # Janet package manager

    # Common Lisp
    # sbcl # Steel Bank Common Lisp

    # Racket (Scheme dialect)
    racket # Racket language

    # Scheme (functional programming language)
    chez # Chez Scheme
    guile # GNU Ubiquitous Intelligent Language for Extensions
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
#     fennel-ls
#     fnlfmt
#     luajitPackages.fennel
#     janet
#     jpm
#     racket
#     chez
#     guile
#   ];
# }
# ---------------------------------------------------------------------------
