{ config, pkgs, ... }:
{
  # ----------------------------------------------------------------------------
  # Bootloader Configuration
  #
  # Configures the bootloader for UEFI systems. Systemd-boot is chosen for its
  # simplicity and integration with systemd.
  # ----------------------------------------------------------------------------
  boot.loader = {
    # Use systemd-boot as the bootloader.
    systemd-boot = {
      enable = true;
      # Add a boot menu option for Memtest86+, a memory testing tool.
      memtest86.enable = true;
    };

    # Configure EFI settings.
    efi = {
      # Allow the bootloader to write to EFI variables. This is necessary for
      # managing boot entries automatically.
      canTouchEfiVariables = true;
      # Specify the mount point for the EFI System Partition (ESP).
      efiSysMountPoint = "/boot/efi";
    };
  };

  # ----------------------------------------------------------------------------
  # Kernel Selection
  #
  # The stable Linux kernel is used by default to avoid potential issues with
  # newer, less-tested versions. For example, previous attempts to use the
  # latest kernel resulted in Btrfs corruption and broken VirtualBox support.
  # ----------------------------------------------------------------------------
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # ----------------------------------------------------------------------------
  # Kernel Runtime Parameters (Sysctl)
  # ----------------------------------------------------------------------------
  boot.kernel.sysctl = {
    # Lower `vm.swappiness` to reduce aggressive swapping to the disk.
    # This improves system responsiveness, especially on systems with ample RAM,
    # by making the kernel favor keeping data in RAM instead of swapping it out.
    # A value of 10 is a common and balanced choice.
    "vm.swappiness" = 10;
  };

  # ----------------------------------------------------------------------------
  # Kernel Boot Parameters
  #
  # Disables various CPU speculative execution mitigations to improve
  # performance. This can be particularly beneficial on older Intel CPUs
  # (pre-10th gen).
  #
  # WARNING: Disabling these mitigations introduces security risks, as it could
  # allow sensitive information (e.g., cryptographic secrets) to leak between
  # different tasks on the system. This configuration prioritizes performance
  # over security from these specific hardware vulnerabilities.
  #
  # For more details on kernel parameters, see:
  # https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
  # ----------------------------------------------------------------------------
  boot.kernelParams = [
    # Generic toggle for all mitigations
    "mitigations=off" # Disables a wide range of security mitigations (Spectre, Meltdown, etc.).

    # Spectre & Meltdown related mitigations
    "noibpb" # Disables Indirect Branch Prediction Barrier.
    "noibrs" # Disables Indirect Branch Restricted Speculation.
    "nopti" # Disables Kernel Page Table Isolation (Meltdown mitigation).
    "nospectre_v1" # Disables Spectre Variant 1 mitigation.
    "nospectre_v2" # Disables Spectre Variant 2 mitigation.
    "nospec_store_bypass_disable" # Disables Speculative Store Bypass mitigation.
    "no_stf_barrier" # Disables Store-to-Load Forwarding barrier.

    # Other hardware vulnerability mitigations
    "l1tf=off" # Disables L1 Terminal Fault (L1TF) mitigation.
    "mds=off" # Disables Microarchitectural Data Sampling (MDS) mitigation.

    # Performance-related tweaks
    "tsx=on" # Enables Transactional Synchronization Extensions (TSX) for better performance.
    "tsx_async_abort=off" # Disables a specific TSX mitigation (Async Abort).
  ];

  # ----------------------------------------------------------------------------
  # Temporary Files Management
  # ----------------------------------------------------------------------------
  # Clears the /tmp directory on every boot.
  # This is useful for ensuring a clean state for temporary files.
  # boot.tmp.cleanOnBoot = true;

}
