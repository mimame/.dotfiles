# ----------------------------------------------------------------------------
# Graphics Configuration (NVIDIA Optimus)
#
# This file configures the graphics stack, with a focus on a hybrid setup
# involving both Intel and NVIDIA GPUs (NVIDIA Optimus).
# ----------------------------------------------------------------------------
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Accept the NVIDIA driver license.
  nixpkgs.config.nvidia.acceptLicense = true;

  # Enable the core graphics stack.
  hardware.graphics = {
    enable = true;
    # Install packages for VA-API, enabling hardware-accelerated video decoding.
    # This offloads video playback from the CPU to the GPU, saving power.
    extraPackages = with pkgs; [
      nvidia-vaapi-driver # NVIDIA's VA-API implementation
      libva-vdpau-driver # VDPAU backend for VA-API
      libvdpau-va-gl # VA-API/VDPAU interoperability
    ];
  };

  # Set the primary X.org video driver to NVIDIA.
  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];

  # ----------------------------------------------------------------------------
  # NVIDIA Driver Settings
  # ----------------------------------------------------------------------------
  hardware.nvidia = {
    # The NVIDIA driver package is typically determined automatically.
    # Manual overrides for specific versions (e.g., legacy) can be set here.
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

    # Disable the persistence daemon. It keeps the driver loaded even when not
    # in use, which can consume unnecessary power on an Optimus laptop.
    nvidiaPersistenced = false;

    # Enable the `nvidia-settings` utility for graphical configuration.
    nvidiaSettings = true;

    # Use kernel modesetting (KMS). This is required for modern display
    # servers like Wayland and provides a smoother boot experience.
    modesetting.enable = true;

    # Power management features. Can be unstable.
    # Enable this if you experience graphical corruption after waking from sleep.
    # It works by saving the entire VRAM to system RAM during suspend.
    powerManagement.enable = false;

    # Use the proprietary kernel module. Set to `true` to use the open-source module.
    open = false;

    # --------------------------------------------------------------------------
    # PRIME Settings for NVIDIA Optimus
    #
    # Configures PRIME for rendering on the NVIDIA GPU and displaying on the
    # screen connected to the Intel GPU.
    # --------------------------------------------------------------------------
    prime = {
      # Enable PRIME Sync to prevent screen tearing in hybrid graphics setups.
      sync.enable = true;

      # IMPORTANT: These Bus IDs are specific to this machine's hardware.
      # To find the correct IDs for your system, run: `lspci | grep -E 'VGA|3D'`
      nvidiaBusId = "PCI:01:00:0";
      intelBusId = "PCI:00:02:0";
    };
  };

  # --- Historical/Alternative Configurations (Disabled) ---
  # These are kept for reference but are not currently active.

  # CUDA support
  # nixpkgs.config.cudaSupport = true;

  # Attempts to force NVIDIA by blacklisting the Intel driver.
  # This is generally not the recommended approach for Optimus.
  # boot.kernelParams = lib.mkDefault [ "module_blacklist=i915" ];
  # boot.blacklistedKernelModules = lib.mkDefault [ "i91is5" ];

  # PRIME Render Offload, an alternative to the sync method.
  # offload = {
  #   enable = true;
  #   enableOffloadCmd = true;
  # };
}
