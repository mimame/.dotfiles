{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    # Graphics and image manipulation
    (flameshot.override { enableWlrSupport = true; }) # Screenshot tool
    gimp3 # GNU Image Manipulation Program
    inkscape # Vector graphics editor
  ];
}
