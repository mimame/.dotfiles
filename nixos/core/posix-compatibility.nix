# ----------------------------------------------------------------------------
# POSIX & FHS Compatibility Layer
#
# This configuration aims to improve compatibility with binaries and scripts
# that are not packaged for NixOS. It sets up an environment that mimics the
# standard Filesystem Hierarchy Standard (FHS) expected by most Linux software,
# allowing for the execution of pre-compiled binaries and scripts with
# hardcoded paths (e.g., `/usr/bin/env`).
# ----------------------------------------------------------------------------
{ pkgs, ... }:
let
  # Fetch the `nix-alien` package set directly from the latest `master` branch.
  # `nix-alien` is a tool that helps run unmodified binaries on NixOS.
  # Using `master` provides the newest features at the cost of potential instability.
  nix-alien-pkgs =
    import (fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master")
      { };
in
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

  # Install the `nix-alien` utility into the system environment.
  # This command can be used to wrap and run pre-compiled binaries,
  # automatically setting up the necessary environment and library paths.
  # It leverages `nix-ld` and other mechanisms to achieve this.
  environment.systemPackages = with nix-alien-pkgs; [ nix-alien ];
}
