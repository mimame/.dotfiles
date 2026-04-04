# ----------------------------------------------------------------------------
# POSIX & FHS Compatibility Layer
#
# Provides compatibility for non-NixOS binaries and scripts that expect
# standard Linux filesystem hierarchy (FHS).
#
# Uses lightweight compatibility layers:
# - envfs: Fixes hardcoded paths like /usr/bin/env in scripts
# - nix-ld: Allows non-NixOS binaries to find shared libraries
#
# NOTE: nix-alien was removed for better build stability and faster evaluation.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # Create virtual FHS-compliant filesystem for scripts with hardcoded shebangs
  services.envfs.enable = true;

  # Provide dynamic linker for non-NixOS binaries
  programs.nix-ld = {
    enable = true;
    # Common libraries expected by most programs
    libraries = with pkgs; [
      curl
      stdenv.cc.cc # libc
      zlib
    ];
  };
}
