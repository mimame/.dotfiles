{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    # Graphics and image manipulation
    gimp3 # GNU Image Manipulation Program
    grim # Wayland screenshot tool
    slurp # Select a region in a Wayland compositor
    swappy # Snapshot and edit tool for Wayland
    inkscape # Vector graphics editor
  ];
}
