# ----------------------------------------------------------------------------
# Printing Services (CUPS)
#
# This file configures the Common Unix Printing System (CUPS) and related
# services for network printer discovery.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # Enable the CUPS printing service.
  services.printing = {
    enable = true;
    # Install specific drivers for the Brother MFC-L2720DW printer.
    # Drivers are pulled from the unstable channel for better hardware support.
    drivers = with pkgs.unstable; [
      mfcl2720dwlpr
      mfcl2720dwcupswrapper
    ];
  };

  # Enable Avahi for zero-configuration networking (mDNS/DNS-SD).
  # This is essential for discovering network printers, scanners, and other
  # services on the local network automatically.
  services.avahi = {
    enable = true;
    package = pkgs.unstable.avahi;
    # Open the firewall for mDNS traffic.
    openFirewall = true;
    # Enable NSS integration for .local domain resolution.
    # IMPORTANT: This is required to connect to devices using their .local
    # hostname (e.g., `My-Printer.local`). Without it, connections will fail.
    nssmdns4 = true;
    nssmdns6 = true;
  };
}
