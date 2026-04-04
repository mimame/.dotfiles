# ----------------------------------------------------------------------------
# DMS-Shell Configuration
#
# Desktop Management System Shell for Niri with self-healing capabilities.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
let
  vars = import ../../variables.nix;
in
{
  # Inject unstable packages into global scope for dms-shell module
  # TODO: Remove once NixOS 26.05 is released (packages in stable)
  nixpkgs.overlays = [
    (final: prev: {
      inherit (final.unstable) dgop dsearch;
    })
  ];

  # Import unstable dms-shell module
  imports = [ "${vars.unstableSrc}/nixos/modules/programs/wayland/dms-shell.nix" ];

  programs.dms-shell = {
    enable = true;
    package = pkgs.unstable.dms-shell;
    quickshell.package = pkgs.unstable.quickshell;
  };

  # Self-healing configuration for DMS-Shell
  # Automatically restarts on crashes or during NixOS switches
  systemd.user.services.dms = {
    serviceConfig = {
      Restart = "always";
      RestartSec = "3s"; # Allow D-Bus/Portals time to settle
      StartLimitIntervalSec = "60s";
      StartLimitBurst = 5;
    };
    unitConfig.PartOf = [ "graphical-session.target" ];
  };

  environment.systemPackages = with pkgs; [ dsearch ];
}
