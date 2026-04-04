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
  # WHY: The default NixOS Niri module enables portals but doesn't define
  # routing (config.niri). Without this, applications don't know which portal
  # backend to use for screen sharing/file pickers, causing slow startup or hangs.
  # This explicitly prioritizes GNOME portal (required for Niri screencasting)
  # with GTK fallback, ensuring deterministic and reliable behavior.
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

  # Systemd service for automatic disk mounting
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
    xwayland-satellite # XWayland utility for X11 app compatibility on Wayland
  ];
}
