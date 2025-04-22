{ pkgs, ... }:
{

  # Enable all firmware regardless of license
  hardware.enableAllFirmware = true;

  services.fwupd.enable = true;

  environment.systemPackages =
    with pkgs;
    [
      firmwareLinuxNonfree
    ]
    ++ (with pkgs.unstable; [

    ]);
}
