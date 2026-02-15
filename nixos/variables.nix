# ----------------------------------------------------------------------------
# Global Variables
#
# This file defines the "Single Source of Truth" for the system configuration.
#
# USAGE:
# These variables are injected into the NixOS module system via `_module.args`
# in `configuration.nix`.
#
# - In normal modules: Request `{ vars, username, ... }` as arguments.
# - In imports blocks: Import this file manually (args are not available yet).
# ----------------------------------------------------------------------------
{
  hostname = "narnia";
  username = "mimame";
  desktop = "niri";
  scannerIp = "192.168.1.39";

  # Unstable Source
  # Used to import modules or packages from unstable.
  unstableSrc = fetchTarball "https://github.com/nixos/nixpkgs/tarball/nixos-unstable";
}
