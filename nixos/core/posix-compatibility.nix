# ----------------------------------------------------------------------------
# POSIX & FHS Compatibility Layer
#
# This configuration aims to improve compatibility with binaries and scripts
# that are not packaged for NixOS. It sets up an environment that mimics the
# standard Filesystem Hierarchy Standard (FHS) expected by most Linux software.
#
# DESIGN CHOICE:
# `nix-alien` was previously used but has been removed to improve build
# stability and evaluation speed. It is a heavy dependency that fetches large
# databases during evaluation.
#
# The configuration now relies on the lightweight, passive compatibility layers:
# 1. `envfs`: Fixes hardcoded paths like `/usr/bin/env` in scripts.
# 2. `nix-ld`: Allows non-NixOS binaries to find standard libraries.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # Enable Envfs to create a virtual FHS-compliant filesystem.
  # This service creates symbolic links for common paths like `/bin`, `/usr/bin`,
  # and `/lib` on-the-fly, pointing them to the correct locations in the Nix
  # store. This is crucial for running scripts with hardcoded shebangs
  # (e.g., `#!/bin/bash`).
  services.envfs.enable = true;

  # Enable `nix-ld` to provide a dynamic linker for non-NixOS binaries.
  # This allows binaries compiled on other Linux distributions to find their
  # shared library dependencies within the Nix store.
  programs.nix-ld = {
    enable = true;
    # Provide a default set of common libraries that many programs expect.
    # This list can be expanded if other libraries are frequently needed.
    libraries = with pkgs; [
      curl
      stdenv.cc.cc # Provides libc
      zlib
    ];
  };
}
