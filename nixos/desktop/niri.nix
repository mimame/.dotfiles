{ pkgs, ... }:
let
in
{
  # https://github.com/NixOS/nixpkgs/issues/373273
  # https://github.com/nix-community/nixGL/pull/190
  programs.niri = {
    enable = true;
    # package = pkgs.unstable.niri;
  };

  services.xserver = {
    enable = true;
    # FIXME: Enable lightdm when working
    # displayManager.lightdm.enable = true;
    displayManager.gdm.enable = true;
  };

  services.displayManager = {
    defaultSession = "niri";
    autoLogin = {
      enable = true;
      user = "mimame";
    };
  };

  # systemd units
  systemd = {
    user.services = {
      gammastep = {
        enable = true;
        description = "gammastep";
        wantedBy = [ "niri.service" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.gammastep}/bin/gammastep";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
      swayidle = {
        enable = true;
        description = "swayidle";
        wantedBy = [ "niri.service" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.unstable.swayidle}/bin/swayidle timeout 3600 'systemctl suspend-then-hibernate'";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
      udiskie = {
        enable = true;
        description = "udiskie";
        wantedBy = [ "niri.service" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
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

  security.pam.services.gtklock = { };
  environment.systemPackages =
    with pkgs;
    [
      gtklock
      xwayland-satellite
    ]
    ++ (with pkgs.unstable; [

      swaynotificationcenter
      swayosd
      swayr
      walker
      waybar

    ]);
}
