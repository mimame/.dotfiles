# ----------------------------------------------------------------------------
# Niri Wayland Compositor Configuration
#
# Scrollable-tiling Wayland compositor with explicit portal routing.
# ----------------------------------------------------------------------------
{ pkgs, username, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.unstable.niri;
  };

  # Explicit portal configuration for Niri
  # Ensures deterministic backend selection for screen sharing and file pickers
  xdg.portal.config.niri = {
    default = [
      "gnome" # Required for Niri screencasting
      "gtk"
    ];
  };

  # Display manager configuration
  services.displayManager = {
    defaultSession = "niri";
    autoLogin = {
      enable = true;
      user = "${username}";
    };
  };

  # Systemd services
  systemd.user.services.udiskie = {
    enable = true;
    description = "Udiskie automounter";
    wantedBy = [ "niri.service" ];
    wants = [ "niri.service" ];
    after = [ "niri.service" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.unstable.udiskie}/bin/udiskie --notify --smart-tray --event-hook notify-send";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite # XWayland utility for X11 app compatibility
  ];
}
