# ----------------------------------------------------------------------------
# Graphics Configuration
#
# Base graphics stack (Mesa/VA-API) with Intel-specific optimizations.
# Host-specific GPU configs (NVIDIA) are in hosts/*/nvidia.nix
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # VA-API driver for Intel Broadwell+ (Gen 8+)
      intel-vaapi-driver # VA-API driver for older Intel GPUs
      libvdpau-va-gl # VDPAU backend using VA-API (for apps requiring VDPAU)
    ];
  };
}
