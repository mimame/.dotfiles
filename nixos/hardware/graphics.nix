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
    # Mode 3 enables both GuC and HuC:
    # - GuC (Graphics microController): Offloads GPU scheduling and command
    #   submission from CPU, reducing overhead and improving window animation
    #   smoothness. Critical for high-refresh or Wayland/Niri compositors.
    # - HuC (HEVC/H.264 microController): Handles firmware-based video
    #   authentication and enables hardware-accelerated decoding/encoding.
    # Combined effect: Smoother UI and lower CPU usage during media playback.
    "i915.enable_guc=3"
  ];
}
