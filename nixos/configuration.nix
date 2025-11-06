# ----------------------------------------------------------------------------
# Main NixOS Entry Point
#
# This file serves as the primary entry point for the NixOS system
# configuration. It defines the specific hostname for this machine and
# then imports the corresponding host-specific configuration module.
#
# This modular approach allows for easy management of multiple NixOS hosts
# from a single repository without relying on Nix flakes.
#
# For a deep dive into NixOS configuration, refer to the official manual:
# https://nixos.org/manual/nixos/stable/
# ----------------------------------------------------------------------------
{
  config, # The aggregated configuration of all imported modules.
  pkgs, # The default Nixpkgs package set.
  ... # Catch-all for other arguments (e.g., `lib`, `modulesPath`).
}:
let
  # Import the shared variables
  vars = import ./variables.nix;
in
{
  # Import the host-specific configuration module.
  # This module defines the system's configuration based on the hostname.
  imports = [
    (import ./hosts/${vars.hostname}/configuration.nix {
      inherit config pkgs vars;
    })
  ];
}
