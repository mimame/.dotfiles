# ----------------------------------------------------------------------------
# DMS-Shell Configuration
#
# Desktop Management System Shell for Niri with self-healing capabilities.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  programs.dms-shell = {
    enable = true;
    package = pkgs.unstable.dms-shell;
    quickshell.package = pkgs.unstable.quickshell;
  };

  # Self-healing configuration for DMS-Shell
  # WHY: DMS-Shell can crash or be terminated during:
  # - NixOS switches (service restarts)
  # - Input device changes (evdev errors)
  # Systemd automatically restarts it with a 3s delay for D-Bus/Portals to settle
  systemd.user.services.dms = {
    serviceConfig = {
      Restart = "always";
      RestartSec = "3s"; # Allow D-Bus/Portals time to settle
    };
    unitConfig = {
      PartOf = [ "graphical-session.target" ];
      StartLimitIntervalSec = "60s";
      StartLimitBurst = 5;
    };
  };

  environment.systemPackages = with pkgs; [ dsearch ];
}
