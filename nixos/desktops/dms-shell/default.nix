{ pkgs, ... }:
let
  vars = import ../../variables.nix;
in
{
  nixpkgs.overlays = [
    (final: prev: {
      # The dms-shell unstable module expects dgop to be in the main pkgs set
      inherit (final.unstable) dgop;
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
    # quickshell.package = pkgs.unstable.quickshell;
  };
}
