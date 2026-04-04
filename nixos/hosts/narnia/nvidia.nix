# ----------------------------------------------------------------------------
# NVIDIA GPU Configuration for Narnia (Tongfang GK5CN6Z / Recoil II)
#
# Hardware: NVIDIA GeForce GTX 1060 Mobile (6GB GDDR5, 2018)
# - Architecture: Pascal (GP106M)
# - CUDA Cores: 1280
# - Memory: 6GB GDDR5
# - TDP: 80W
# - Hybrid Graphics: NVIDIA Optimus with Intel UHD 630
#
# This module configures the NVIDIA GPU with PRIME Offload for optimal
# battery life and performance when needed.
# ----------------------------------------------------------------------------
{ lib, ... }:
{
  # Accept NVIDIA proprietary driver license.
  nixpkgs.config.nvidia.acceptLicense = true;

  # Use NVIDIA as the primary X.org video driver.
  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];

  hardware.nvidia = {
    # Use proprietary kernel module (better performance than nouveau/open).
    # The open-source nvidia-open driver doesn't support Pascal (GTX 1060).
    open = false;

    # Disable persistence daemon to save power when GPU is idle.
    # On Optimus laptops, this prevents unnecessary power consumption.
    nvidiaPersistenced = false;

    # Enable nvidia-settings GUI for manual configuration.
    nvidiaSettings = true;

    # Enable kernel modesetting for Wayland support and smoother boot.
    modesetting.enable = true;

    # Power management for suspend/hibernate stability.
    # Saves VRAM to system RAM to prevent corruption on resume.
    powerManagement.enable = true;

    # Fine-grained power management: GPU powers down completely when idle.
    # Critical for battery life on laptops with Optimus.
    powerManagement.finegrained = true;

    # PRIME Offload configuration for hybrid graphics.
    prime = {
      offload = {
        enable = true;
        # Provides nvidia-offload command for manual GPU selection.
        enableOffloadCmd = true;
      };

      # Disable PRIME Sync (always-on GPU rendering).
      sync.enable = lib.mkForce false;

      # PCI Bus IDs for this specific hardware configuration.
      # Found via: lspci | grep -E 'VGA|3D'
      # 00:02.0 VGA compatible controller: Intel UHD 630
      # 01:00.0 3D controller: NVIDIA GTX 1060 Mobile
      intelBusId = "PCI:00:02:0";
      nvidiaBusId = "PCI:01:00:0";
    };
  };
}
