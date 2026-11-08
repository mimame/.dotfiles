# ----------------------------------------------------------------------------
# Base Desktop Configuration
#
# Common desktop settings and applications for all desktop environments.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # Set ghostty as default terminal for "Open With" dialogs and xdg-terminal-exec
  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "com.mitchellh.ghostty.desktop" ];
  };

  # Icon-theme fallback required by WhiteSur's own index.theme
  # WHY: WhiteSur-dark declares "Inherits=hicolor,breeze", but breeze was
  # never installed, so the inheritance chain dead-ends. Any storage/media
  # icon name (udiskie's tray "drive-removable-media-*", etc.) resolves to
  # null and DMS renders its missing-icon placeholder. Installing
  # breeze-icons completes the chain WhiteSur already points at; no udiskie
  # or theme configuration changes are needed.
  environment.systemPackages = [ pkgs.kdePackages.breeze-icons ];

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
