# ----------------------------------------------------------------------------
# NVIDIA Graphics Configuration (Generic)
#
# Host-specific NVIDIA configurations have been moved to individual host
# directories (e.g., nixos/hosts/narnia/nvidia.nix).
#
# This file is kept for potential future shared NVIDIA configuration across
# multiple hosts with different GPU models.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  hardware.graphics = {
    # VA-API packages for hardware-accelerated video decoding.
    # These are commonly needed across NVIDIA setups.
    extraPackages = with pkgs; [
      nvidia-vaapi-driver # NVIDIA's VA-API implementation
      libva-vdpau-driver # VDPAU backend for VA-API
    ];
  };
}
