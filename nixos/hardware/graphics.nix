# { }:
{
  # nixpkgs.config.nvidia.acceptLicense = true;
  # nixpkgs.config.cudaSupport = false;
  # boot.initrd.kernelModules = [ "nvidia" ];
  # KMS will load the module, regardless of blacklisting
  # boot.kernelParams = lib.mkDefault [
  #   "module_blacklist=i915"
  #   "i915.modeset=0"
  # ];
  # boot.blacklistedKernelModules = lib.mkDefault [ "i915" ];
  # boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   driSupport32Bit = true;
  # extraPackages = with pkgs; [
  #   nvidia-vaapi-driver
  #   vaapiVdpau
  #   libvdpau-va-gl
  # ];
  # };
  # services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
  # # services.xserver.videoDrivers = lib.mkDefault [ "nvidiaLegacy470" ];
  # hardware.nvidia = {
  #   # package = config.boot.kernelPackages.nvidiaPackages.latest;
  #   package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  #   # package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  #   nvidiaPersistenced = false;
  #   # Enable the Nvidia settings menu,
  #   # accessible via `nvidia-settings`.
  #   nvidiaSettings = true;
  #   # Modesetting is required.
  #   modesetting.enable = true;
  #   # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
  #   # Enable this if you have graphical corruption issues or application crashes after waking
  #   # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
  #   # of just the bare essentials.
  #   powerManagement.enable = false;
  #   # Use the NVidia open source kernel module (not to be confused with the
  #   # independent third-party "nouveau" open source driver).
  #   open = false;
  #   # prime = {
  #   #   reverseSync.enable = true;
  #   #   # Enable if using an external GPU
  #   #   allowExternalGpu = false;
  #   #   offload = {
  #   #     enable = lib.mkOverride 990 true;
  #   #     enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable
  #   #       true; # Provides `nvidia-offload` command.
  #   #   };
  #   #   # Hardware should specify the bus ID for intel/nvidia devices with lspci
  #   #   # lspci | grep -E 'VGA|3D
  #   #   # sudo lshw -c display
  #   #   nvidiaBusId = "PCI:01:00:0";
  #   #   intelBusId = "PCI:00:02:0";
  #   # };
  # };
}
