# ----------------------------------------------------------------------------
# Printing Services (CUPS)
#
# CUPS with Brother MFC-L2720DW drivers and Avahi for network discovery.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      mfcl2720dwlpr
      mfcl2720dwcupswrapper
    ];
  };
}
