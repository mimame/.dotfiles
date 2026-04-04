# ----------------------------------------------------------------------------
# Scanning Services (SANE)
#
# SANE framework with Brother MFC-L2710DW network scanner.
# ----------------------------------------------------------------------------
{ vars, ... }:
{
  services.saned.enable = true; # Network scanning daemon

  hardware.sane = {
    enable = true;
    openFirewall = true;
    # Brother brscan5 driver
    brscan5 = {
      enable = true;
      netDevices.narnia = {
        model = "MFC-L2710DW";
        ip = vars.scannerIp;
      };
    };
  };
}
