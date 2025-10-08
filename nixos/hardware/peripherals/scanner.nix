# ----------------------------------------------------------------------------
# Scanning Services (SANE)
#
# This file configures the Scanner Access Now Easy (SANE) framework for
# using scanners, both locally and over the network.
# ----------------------------------------------------------------------------
{ ... }:
{
  # Enable the SANE network scanning daemon (saned).
  # This allows other computers on the network to access this machine's scanner.
  services.saned.enable = true;

  # Configure the core SANE framework.
  hardware.sane = {
    enable = true;
    # Open the firewall to allow network scanning.
    openFirewall = true;

    # Configure the proprietary Brother `brscan5` driver for a network scanner.
    brscan5 = {
      enable = true;
      # Define the network device.
      netDevices = {
        # A friendly name for the scanner.
        narnia = {
          model = "MFC-L2710DW";
          ip = "192.168.1.39";
        };
      };
    };
  };
}
