# ----------------------------------------------------------------------------
# Global Variables
#
# This file defines the "Single Source of Truth" for the system configuration.
# It auto-detects the hostname and merges shared vars with host-specific vars.
#
# USAGE:
# These variables are injected into the NixOS module system via `_module.args`
# in `configuration.nix`.
#
# - In normal modules: Request `{ vars, username, ... }` as arguments.
# - In imports blocks: Import this file manually (args are not available yet).
#
# HOST DETECTION:
# 1. Set NIXOS_HOST env var (e.g., NIXOS_HOST=vm nixos-rebuild switch)
# 2. Or read from /etc/hostname (default)
# ----------------------------------------------------------------------------
let
  # Auto-detect hostname from env var or /etc/hostname
  detectedHost = builtins.getEnv "NIXOS_HOST";
  rawHostname = builtins.readFile /etc/hostname;
  hostname =
    if detectedHost != "" then
      detectedHost
    else
      builtins.substring 0 (builtins.stringLength rawHostname - 1) rawHostname;

  # Import host-specific variables
  hostVars = import ./hosts/${hostname}/variables.nix;

  # Shared variables across all hosts
  shared = {
    username = "mimame";
    desktop = "niri";

    # Unstable Source
    # Used to import modules or packages from unstable.
    unstableSrc = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  };
in
shared // hostVars // { inherit hostname; }
