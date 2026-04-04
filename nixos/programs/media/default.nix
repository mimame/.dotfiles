# ----------------------------------------------------------------------------
# Media Tools
#
# Image viewers and converters for terminal display.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    artem # Modern terminal image viewer
    chafa # Convert images to ANSI/Unicode art
    imagemagick # Image creation, editing, composition
    jp2a # Convert JPEG to ASCII
    ueberzugpp # Image viewer using Kitty graphics protocol
  ];
}
