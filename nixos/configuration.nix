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
_:
let
  # Import the shared variables
  vars = import ./variables.nix;
in
{
  # Import the host-specific configuration module.
  # This module defines the system's configuration based on the hostname.
  imports = [
    ./hosts/${vars.hostname}/configuration.nix
  ];

  # Make variables available to all modules automatically
  #
  # STRATEGY: Dependency Injection
  # We inject `vars` and common attributes (username, hostname) into the module
  # system args. This decoupling allows modules to request these values as
  # function arguments (e.g., `{ pkgs, username, ... }`) without needing to
  # know the location of `variables.nix`.
  #
  # WHY THIS IS BEST:
  # 1. Decoupling: Sub-modules are path-agnostic. Moving files doesn't break imports.
  # 2. Clarity: Module dependencies are explicit in the function header.
  # 3. Convenience: No boilerplate `let vars = import ...` in every file.
  #
  # NOTE: Imports are resolved BEFORE these args are available, so files performing
  # imports (like `hosts/narnia/configuration.nix`) must still import `variables.nix` manually.
  _module.args = {
    inherit vars;
    inherit (vars) username hostname desktop;
  };
}
