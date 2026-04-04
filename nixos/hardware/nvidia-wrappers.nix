# ----------------------------------------------------------------------------
# NVIDIA Application Wrappers (Generic)
#
# Host-specific NVIDIA wrapper configurations have been moved to individual
# host directories (e.g., nixos/hosts/narnia/nvidia-wrappers.nix).
#
# This file provides the shared wrapNvidia helper function for use across hosts.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # Shared helper function (exported via module system if needed in future).
  # For now, this file is kept minimal as wrappers are host-specific.
}
