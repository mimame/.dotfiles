# ----------------------------------------------------------------------------
# Mouse Configuration
#
# Customizes mouse behavior and enables remapping utilities.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # input-remapper: Easy to use tool to change the mapping of input device buttons.
  # This service is required for applying presets on boot and during the session.
  services.input-remapper = {
    enable = true;
    # Use unstable for latest Wayland fixes and compatibility.
    # Setting this here prevents collisions with the stable package.
    package = pkgs.unstable.input-remapper;
  };

  environment.systemPackages = [
    # xmodmap is an X11 utility, but input-remapper-gtk tries to call it to read keymaps.
    # We include it here to suppress the "failed to call xmodmap" errors in the logs,
    # even though we are on Wayland/Niri.
    pkgs.xmodmap
  ];

  # ----------------------------------------------------------------------------
  # Mouse DPI Optimization
  # ----------------------------------------------------------------------------
  services.udev.extraHwdb = ''
    # Mouse DPI optimization for Sunplus Innovation Technology Inc. USB Optical Mouse
    #
    # Available DPI range: 3200, 2000, 1200, 800
    #
    # How to find the device and verify DPI:
    # 1. Identify input device: ls -l /dev/input/by-id/*
    # 2. Run diagnostic: mouse-dpi-tool /dev/input/eventX
    #
    # Historical reference:
    # - mouse:usb:v1bcfp0053:name:USB Optical Mouse  Mouse:
    # - MOUSE_DPI=2000@145
    mouse:usb:*
     MOUSE_DPI=3200@145
  '';
}
