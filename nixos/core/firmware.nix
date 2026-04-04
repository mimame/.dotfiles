# ----------------------------------------------------------------------------
# Firmware Management
#
# Ensures hardware has necessary firmware for proper operation and allows
# firmware updates via LVFS (Linux Vendor Firmware Service).
# ----------------------------------------------------------------------------
_: {
  # Enable all firmware including non-free (Wi-Fi, GPU, sound, etc.)
  hardware.enableAllFirmware = true;

  # Enable firmware update daemon for motherboard, SSD, and peripheral updates
  services.fwupd.enable = true;
}
