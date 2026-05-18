# ----------------------------------------------------------------------------
# Hardware Configuration for Narnia (Tongfang GK5CN6Z / Recoil II)
#
# Host-specific hardware tweaks, log fixes, and peripheral optimizations.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
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
  # Mouse & Input
  # ----------------------------------------------------------------------------
  services.udev.extraHwdb = ''
    # Mouse DPI optimization for Sunplus Innovation Technology Inc. USB Optical Mouse
    #
    # Available DPI range: 3200, 2000, 1200, 800
    #
    # How to find the device and verify DPI:
    # 1. Identify input device: ls -l /dev/input/by-id/*
    # 2. Run diagnostic: mouse-dpi-tool /dev/input/eventX
    #
    # Historical reference:
    # - mouse:usb:v1bcfp0053:name:USB Optical Mouse  Mouse:
    # - MOUSE_DPI=2000@145
    mouse:usb:*
     MOUSE_DPI=3200@145
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
    # Disable BAP (Basic Audio Profile / LE Audio)
    # WHY: Frequently logs "Unable to find bap session" errors on device
    # detachment on this specific Intel adapter. Disabling it resolves
    # the log spam until LE Audio support matures in BlueZ.
    Disable = "bap";
  };
}
