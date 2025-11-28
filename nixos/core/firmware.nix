_: {
  # ----------------------------------------------------------------------------
  # Firmware Management
  #
  # This section ensures that the system has the necessary firmware to support
  # all its hardware components.
  # ----------------------------------------------------------------------------

  # Enable all available firmware, including non-free and redistributable
  # packages. This is a broad setting that helps ensure that all hardware
  # components (e.g., Wi-Fi, GPU, sound cards) have the firmware they need
  # to function correctly, especially during early boot.
  hardware.enableAllFirmware = true;

  # Enable the Firmware Update Daemon (fwupd).
  # This service allows for updating device firmware from the Linux Vendor
  # Firmware Service (LVFS). It helps keep hardware like motherboards,
  # SSDs, and peripherals up-to-date with the latest security and stability
  # patches provided by their manufacturers.
  services.fwupd.enable = true;

}
