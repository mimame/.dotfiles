{ pkgs, ... }:
{

  # Enable all firmware regardless of license
  hardware.enableAllFirmware = true;

  environment.systemPackages =
    with pkgs;
    [ ]
    ++ (with pkgs.unstable; [

      firmwareLinuxNonfree
    ]);
}
