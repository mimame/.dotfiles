{ pkgs, username, ... }:
{
  # Niri: A scrollable-tiling Wayland compositor.
  programs.niri = {
    enable = true;
    # package = pkgs.unstable.niri;
  };

  # ----------------------------------------------------------------------------
  # Explicit Portal Configuration
  #
  # WHY THIS IS NEW: The default NixOS Niri module enables portals but does not
  # define the "routing" (config.niri).
  #
  # WHAT WAS MISSING: Without this, applications often don't know which portal
  # backend (GNOME or GTK) to talk to for specific tasks like screen sharing or
  # choosing a file, which can lead to slow startup or app "hangs".
  #
  # WHAT THIS DOES: This explicitly tells the system to prioritize the GNOME
  # portal (required for Niri screencasting) and fallback to GTK, ensuring
  # deterministic and reliable behavior across all Wayland apps.
  # ----------------------------------------------------------------------------
  xdg.portal.config.niri = {
    default = [
      "gnome"
      "gtk"
    ];
  };

  # Display Manager configuration for Niri.
  services.displayManager = {
    defaultSession = "niri"; # Set Niri as the default session.
    autoLogin = {
      enable = true; # Enable automatic login.
      user = "${username}"; # Specify the user for auto-login.
    };
  };

  # systemd units
  systemd = {
    user.services = {
      udiskie = {
        enable = true;
        description = "udiskie";
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
    };
  };

  environment.systemPackages = with pkgs; [

    # XWayland utilities
    xwayland-satellite # XWayland utility
  ];
}
