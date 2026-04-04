# ----------------------------------------------------------------------------
# Printing Services (CUPS)
#
# CUPS with Brother MFC-L2720DW drivers and Avahi for network discovery.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = with pkgs.unstable; [
      mfcl2720dwlpr
      mfcl2720dwcupswrapper
    ];
  };

  # Avahi for network printer/scanner discovery (.local domains)
  services.avahi = {
    enable = true;
    package = pkgs.unstable.avahi;
    openFirewall = true;
    nssmdns4 = true; # Required for .local hostname resolution
    nssmdns6 = true;
  };
}
