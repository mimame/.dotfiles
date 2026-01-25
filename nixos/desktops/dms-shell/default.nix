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
  #    currently only in unstable, we must "inject" them into the global scope
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

    # These options are now available via the imported module
    enableSystemMonitoring = true;
    # enableVPN = true;
    # enableDynamicTheming = true;
    # enableAudioWavelength = true;
    # enableCalendarEvents = true;

    # QuickShell package customization if needed
    quickshell.package = pkgs.unstable.quickshell;
  };

  environment.systemPackages = with pkgs; [
    dsearch
  ];
}
