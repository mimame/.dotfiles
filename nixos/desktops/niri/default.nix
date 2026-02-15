{ pkgs, username, ... }:
{
  # Niri: A scrollable-tiling Wayland compositor.
  programs.niri = {
    enable = true;
    # package = pkgs.unstable.niri;
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

  # Whether to run XDG autostart files for sessions without a desktop manager (with only a window manager), these sessions usually don’t handle XDG autostart files by default.
  services.xserver.desktopManager.runXdgAutostartIfNone = true;

  environment.systemPackages = with pkgs; [

    # XWayland utilities
    xwayland-satellite # XWayland utility
  ];
}
