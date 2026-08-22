# ----------------------------------------------------------------------------
# Hardware Configuration for Narnia (Tongfang GK5CN6Z / Recoil II)
#
# Host-specific hardware tweaks, log fixes, and peripheral optimizations.
# ----------------------------------------------------------------------------
{ lib, pkgs, ... }:
{
  # ----------------------------------------------------------------------------
  # USB & Connectivity
  # ----------------------------------------------------------------------------
  services.udev.extraRules = ''
    # Disable problematic USB port 1-6
    # WHY: This internal port experiences persistent hardware-level enumeration
    # failures (error -71). The kernel's constant reset loops cause significant
    # I/O wait and system stutters. Disabling the port stops the reset cycle.
    ACTION=="add", SUBSYSTEM=="usb", KERNEL=="1-6", ATTR{authorized}="0"
  '';

  # ----------------------------------------------------------------------------
  # Graphics (Intel iGPU)
  # ----------------------------------------------------------------------------
  boot.kernelParams = [
    # Enable GuC/HuC firmware loading for Intel Gen 9 (Coffee Lake).
    # Mode 2 enables HuC (HEVC/H.264 microController):
    # - HuC handles firmware-based video authentication and enables hardware-
    #   accelerated decoding/encoding.
    # - Mode 3 (GuC + HuC) is disabled because GuC submission is often
    #   unstable on Coffee Lake (i7-8750H), causing log errors and freezes.
    "i915.enable_guc=2"
  ];

  # ----------------------------------------------------------------------------
  # Bluetooth (Intel Wireless-AC 9260)
  # ----------------------------------------------------------------------------
  hardware.bluetooth.settings.General = {
    # Disable kernel experimental features (including BAP / LE Audio)
    # WHY: This Intel adapter logs "Unable to find bap session" errors on
    # device detachment. KernelExperimental=false disables BAP at the kernel
    # level without using the invalid Disable=bap key that bluez 5.86 rejects.
    KernelExperimental = lib.mkForce false;
  };
}
