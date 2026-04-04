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
  # Accept NVIDIA proprietary driver license
  nixpkgs.config.nvidia.acceptLicense = true;

  # Use NVIDIA as the primary X.org video driver
  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];

  hardware.nvidia = {
    # Use proprietary kernel module (better performance than nouveau/open)
    # WHY: The open-source nvidia-open driver doesn't support Pascal (GTX 1060)
    # Only Turing (GTX 16xx) and newer are supported by nvidia-open
    open = false;

    # Disable persistence daemon to save power when GPU is idle
    # WHY: On Optimus laptops, the daemon keeps the driver loaded even when
    # not in use, consuming unnecessary power. Fine-grained power management
    # (below) handles GPU power down automatically.
    nvidiaPersistenced = false;

    # Enable nvidia-settings GUI for manual configuration
    nvidiaSettings = true;

    # Enable kernel modesetting (KMS)
    # WHY: Required for modern display servers like Wayland
    # Provides smoother boot experience (no mode switch flash)
    modesetting.enable = true;

    # Power management for suspend/hibernate stability
    # WHY: Saves VRAM to system RAM during suspend to prevent corruption on resume
    # Without this, displays may fail to reinitialize after waking from sleep
    powerManagement.enable = true;

    # Fine-grained power management: GPU powers down completely when idle
    # WHY: Critical for battery life on Optimus laptops
    # Allows the NVIDIA GPU to completely power off when not in use,
    # significantly reducing heat and extending battery life
    powerManagement.finegrained = true;

    # PRIME Offload configuration for hybrid graphics
    prime = {
      offload = {
        enable = true;
        # Provides nvidia-offload command for manual GPU selection
        # Applications can use: nvidia-offload <app>
        enableOffloadCmd = true;
      };

      # Disable PRIME Sync (always-on GPU rendering)
      # WHY: Sync mode keeps the NVIDIA GPU active at all times, draining battery
      # Offload mode only activates GPU when explicitly requested, saving power
      sync.enable = lib.mkForce false;

      # PCI Bus IDs for this specific hardware configuration
      # Found via: lspci | grep -E 'VGA|3D'
      # 00:02.0 VGA compatible controller: Intel UHD 630
      # 01:00.0 3D controller: NVIDIA GTX 1060 Mobile
      intelBusId = "PCI:00:02:0";
      nvidiaBusId = "PCI:01:00:0";
    };
  };
}
