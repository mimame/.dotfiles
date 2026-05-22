# ----------------------------------------------------------------------------
# Mouse Configuration
#
# Customizes mouse behavior and enables remapping utilities.
# ----------------------------------------------------------------------------
_: {
  # ----------------------------------------------------------------------------
  # Mouse Remapping (via keyd)
  # ----------------------------------------------------------------------------
  #
  # WHY KEYD OVER INPUT-REMAPPER:
  # 1. Performance: keyd is a lightweight C daemon with minimal overhead.
  # 2. Consistency: Manages both keyboard (Caps Lock) and mouse remapping in one place.
  # 3. Reliability: Handles the hybrid nature of this mouse (1bcf:0053) which
  #    identifies as both a 'Mouse' and a 'Keyboard'.
  #
  # DEVICE-SPECIFIC NOTES:
  # The Sunplus Innovation Mouse (1bcf:0053) reports side-button events as 'mouse1'
  # and 'mouse2'. To capture these, we must explicitly include the device ID in
  # the 'ids' list, as keyd ignores mice by default to avoid interfering with
  # pointer movement.
  #
  # HOW TO DISCOVER NEW BUTTONS:
  # 1. Run: sudo keyd monitor
  # 2. Click the buttons.
  # 3. Look for the name in the output (e.g., "mouse1 down").
  services.keyd.keyboards.mouse-remap = {
    ids = [ "1bcf:0053" ];
    settings = {
      main = {
        # Map side buttons to PageUp/PageDown for reliable scrolling
        mouse1 = "pageup";
        mouse2 = "pagedown";
        # Fallback aliases
        back = "pageup";
        forward = "pagedown";
      };
    };
  };

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
