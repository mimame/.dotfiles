# ----------------------------------------------------------------------------
# Base Desktop Configuration
#
# Common desktop settings and applications for all desktop environments.
# ----------------------------------------------------------------------------
{ ... }:
{
  # Set ghostty as default terminal for "Open With" dialogs and xdg-terminal-exec
  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "com.mitchellh.ghostty.desktop" ];
  };

  # Enable XDG autostart for window managers without a desktop manager
  services.xserver.desktopManager.runXdgAutostartIfNone = true;

  # Input method for text completion and emojis (disabled by default)
  # i18n.inputMethod = {
  #   enable = true;
  #   type = "ibus";
  #   ibus.engines = with pkgs.unstable.ibus-engines; [ typing-booster uniemoji ];
  # };

  imports = [
    ./apps/browsers.nix
    ./apps/communication.nix
    ./apps/development.nix
    ./apps/graphics.nix
    ./apps/media.nix
    ./apps/networking.nix
    ./apps/notes.nix
    ./apps/security.nix
    ./apps/utilities.nix
  ];
}
