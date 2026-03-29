{ pkgs, ... }:
let
  vars = import ../../variables.nix;
in
{
  # ----------------------------------------------------------------------------
  # Nixpkgs Integration
  #
  # There is a fundamental difference between installing a program and
  # configuring a module:
  #
  # 1. environment.systemPackages (Installation):
  #    Adds binaries to the system PATH so they can be run from the terminal.
  #
  # 2. nixpkgs.overlays (Integration):
  #    The dms-shell module (imported below) expects certain packages (dgop,
  #    dsearch) to be available in the main 'pkgs' set. Since these are
  #    currently only in unstable, must "inject" them into the global scope
  #    so the module's internal services can find them.
  #
  # TODO: Remove this overlay once NixOS 26.05 is released, as these packages
  # should be available in the stable channel by then.
  # ----------------------------------------------------------------------------
  nixpkgs.overlays = [
    (final: prev: {
      # The dms-shell unstable module expects dgop and dsearch to be in the main pkgs set
      inherit (final.unstable) dgop dsearch;
    })
  ];

  imports = [
    "${vars.unstableSrc}/nixos/modules/programs/wayland/dms-shell.nix"
  ];

  programs.dms-shell = {
    enable = true;

    # Use the unstable package from the global overlay
    package = pkgs.unstable.dms-shell;

    # QuickShell package customization if needed
    quickshell.package = pkgs.unstable.quickshell;
  };

  # ----------------------------------------------------------------------------
  # Self-Healing Service Configuration
  #
  # DMS-Shell can occasionally crash or be terminated during NixOS switches
  # or when input devices change (evdev errors). Systemd is configured to
  # automatically restart it.
  # ----------------------------------------------------------------------------
  systemd.user.services.dms = {
    serviceConfig = {
      Restart = "always";
      RestartSec = "3s"; # Give D-Bus/Portals time to settle
      StartLimitIntervalSec = "60s";
      StartLimitBurst = 5;
    };
    # Ensure the service is part of the graphical session
    unitConfig = {
      PartOf = [ "graphical-session.target" ];
    };
  };

  environment.systemPackages = with pkgs; [
    dsearch
  ];
}
