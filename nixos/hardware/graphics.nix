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

  boot.kernelParams = [
    # Enable GuC/HuC firmware loading for Intel Gen 9+ (Skylake and newer)
    # Mode 2 enables HuC (HEVC/H.264 microController):
    # - HuC handles firmware-based video authentication and enables hardware-
    #   accelerated decoding/encoding.
    # - Mode 3 (GuC + HuC) is disabled here because GuC submission is often
    #   unsupported or unstable on Coffee Lake, causing log errors.
    "i915.enable_guc=2"
  ];
}
