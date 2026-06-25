# ----------------------------------------------------------------------------
# Printing Services (CUPS)
#
# CUPS with Brother MFC-L2720DW drivers. Printer uses a static IP
# (same as scanner: 192.168.1.39). Socket activation starts CUPS only
# when a print job is submitted.
# Avahi is configured in hardware/networking.nix (needed for .local SSH).
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    startWhenNeeded = true; # Socket activation
    drivers = with pkgs; [
      mfcl2720dwlpr
      mfcl2720dwcupswrapper
    ];
  };
}
