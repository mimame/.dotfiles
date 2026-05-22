# ----------------------------------------------------------------------------
# Keyboard Configuration
#
# Customizes keyboard behavior and enables remapping utilities.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  services = {
    # Keyboard Layout & XKB Configuration
    # These settings define the system-wide keyboard mapping. While XServer
    # is not explicitly enabled, these XKB parameters are used as the baseline
    # by Wayland compositors (like Niri) and the Linux console.
    xserver.xkb = {
      layout = "us";
      variant = "altgr-intl";
    };

    # Enable and configure keyd for advanced, ergonomic key remapping.
    # This setup applies to all keyboards and introduces two main features:
    # 1. Dual-function Caps Lock: Acts as Control when held, and Escape when tapped.
    # 2. Oneshot Modifiers: Ctrl, Alt, Meta, and Shift can be tapped once to modify
    #    the next key press, reducing the need to hold them down for shortcuts.
    #
    # NOTE ON GROUPS: Do NOT create a 'keyd' group in NixOS for this service.
    # While the daemon logs a warning about a missing 'keyd' group, creating it
    # causes the service to CRASH with 'setgid: Operation not permitted'.
    # This is because the NixOS keyd module enables security hardening
    # (NoNewPrivileges=true and RestrictSUIDSGID=true) which blocks the
    # daemon from changing its group ID even if the group exists.
    keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "overload(control, esc)";
              # Oneshot modifiers can be dangerous. For example, the meta key can
              # block the tiling manager and other apps that expect key combinations.
              # While it's more natural to not have to hold down the keys, it can
              # be difficult to get used to.
              # control = "oneshot(control)";
              # leftalt = "oneshot(alt)";
              # meta = "oneshot(meta)";
              # rightalt = "oneshot(altgr)";
              # shift = "oneshot(shift)";
            };
          };
        };
      };
    };
  };

  # Configure console keymap to match the XKB layout
  console.useXkbConfig = true;

  # Enable uinput support for user-level input handling (required by keyd)
  hardware.uinput.enable = true;
}
