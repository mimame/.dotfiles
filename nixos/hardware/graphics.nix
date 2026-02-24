# ----------------------------------------------------------------------------
# Base Graphics Configuration
#
# This file configures the core graphics stack (Mesa/VA-API) and Intel-specific
# optimizations. Generic settings here apply to all hosts with a GPU.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # Enable the core graphics stack (formerly hardware.opengl).
  hardware.graphics = {
    enable = true;

    # Install generic VA-API and VDPAU drivers.
    extraPackages = with pkgs; [
      intel-media-driver # VA-API for Broadwell+
      intel-vaapi-driver # VA-API for older Intel
      libvdpau-va-gl # VDPAU/VA-API wrapper
    ];
  };

  boot.kernelParams = [
    # Enable GuC/HuC firmware loading for Intel graphics (Gen 9+).
    # - GuC (Graphics microController): Offloads GPU scheduling and command
    #   submission from the CPU, resulting in lower overhead and smoother
    #   window animations (critical for high-refresh or Wayland/Niri setups).
    # - HuC (HEVC/H.264 microController): Handles video authentication and
    #   hardware-accelerated decoding/transcoding.
    # Combined (mode 3) this improves UI fluidity and lowers CPU usage
    # during media playback.
    "i915.enable_guc=3"
  ];
}
