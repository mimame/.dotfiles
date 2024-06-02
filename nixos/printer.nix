{ pkgs, ... }:
{

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs.unstable; [
      mfcl2720dwlpr
      mfcl2720dwcupswrapper
    ];
  };

  # Service discovery on a local network
  services.avahi = {
    enable = true;
    package = pkgs.unstable.avahi;
    openFirewall = true;
    # Important to resolve .local domains of printers, otherwise you get an error
    # like  "Impossible to connect to XXX.local: Name or service not known"
    nssmdns4 = true;
    nssmdns6 = true;
  };
}
