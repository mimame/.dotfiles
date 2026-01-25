# ----------------------------------------------------------------------------
# Host-Specific NixOS Configuration: narnia
#
# This file defines the NixOS configuration specific to the host named "narnia".
# It is imported by the main `configuration.nix` and combines common modules
# with host-specific settings.
#
# The `hostname` argument is passed from the main configuration, allowing
# this module to adapt its behavior or import paths based on the host.
#
# For a deep dive into NixOS configuration, refer to the official manual:
# https://nixos.org/manual/nixos/stable/
# ----------------------------------------------------------------------------
{
  config,
  pkgs,
  ...
}:
let
  # Import variables locally to resolve imports without infinite recursion
  vars = import ../../variables.nix;
  # Fetch the nixpkgs-unstable channel as a tarball.
  unstableTarball = fetchTarball "https://github.com/nixos/nixpkgs/tarball/nixos-unstable";
in
{
  # A list of insecure packages that are explicitly allowed to be installed.
  # This should be used with caution.
  nixpkgs.config.permittedInsecurePackages = [ ];

  # ----------------------------------------------------------------------------
  # Modular Imports
  #
  # This section imports various modular components that define the system's
  # behavior, hardware support, user environments, and installed programs.
  # Paths use `../../` to refer to modules in the parent `nixos` directory.
  # ----------------------------------------------------------------------------
  imports = [
    # Automatically generated hardware configuration.
    ./hardware-configuration.nix

    # --- Core System Configuration ---
    # Essential system-wide settings and configurations.
    ../../core/boot.nix
    ../../core/firmware.nix
    ../../core/lix.nix
    ../../core/nix-config.nix
    ../../core/posix-compatibility.nix

    # --- Hardware Support ---
    # Modules for specific hardware components and peripherals.
    ../../hardware/bluetooth.nix
    ../../hardware/cpu.nix
    ../../hardware/graphics.nix
    ../../hardware/networking.nix
    ../../hardware/peripherals/printer.nix
    ../../hardware/peripherals/scanner.nix
    ../../hardware/sound.nix
    ../../hardware/time.nix

    # --- Device-Specific Profiles ---
    # Profiles tailored for specific device types (e.g., laptops, desktops).
    ../../profiles/laptop.nix

    # --- Base System Services & Settings ---
    # Fundamental system services and configurations.
    ../../system/base.nix
    ../../system/btrfs.nix

    ../../system/fonts.nix

    # --- Programs & Development Environments ---
    ../../programs/default.nix
    ../../programs/languages/default.nix

    # --- User Accounts ---
    # User-specific configurations and settings.
    ../../users/${vars.username}/default.nix

    # --- Desktop Environment ---
    # Configuration for the graphical desktop environment.
    # The GNOME compatibility layer must be loaded before the specific desktop
    # environment to ensure all GNOME-related services and settings are available.
    ../../desktops/gnome_layer.nix
    ../../desktops/base.nix
    ../../desktops/${vars.desktop}/default.nix
    ../../desktops/dms-shell/default.nix
  ];

  # ----------------------------------------------------------------------------
  # Nixpkgs Configuration
  # ----------------------------------------------------------------------------

  # Overlays are the standard, modern way to extend the Nix package set.
  #
  # WHY THIS IS BEST:
  # 1. Recommended: This is the official and most robust approach.
  # 2. Composable: Multiple modules can add to `nixpkgs.overlays` without conflict.
  # 3. Global Scope: They operate at a low level, ensuring every instance of `pkgs`
  #    passed to modules (even deep in the tree) includes the `unstable` attribute.
  # 4. Safe Syntax: The `(final: prev: { ... })` pattern allows referencing the
  #    final aggregated package set, which is safer for complex overrides.
  nixpkgs = {
    overlays = [
      (final: prev: {
        unstable = import unstableTarball {
          inherit (config.nixpkgs) config;
        };
      })
    ];

    config = {
      # A list of insecure packages that are explicitly allowed to be installed.
      # This should be used with caution.
      permittedInsecurePackages = [ ];

      # Allow the installation of packages with non-free licenses.
      allowUnfree = true;

      # Use an overlay to add custom package overrides.
      packageOverrides = pkgs: {
        # Nullify packages with abusive telemetry or undesirable features.
        # This prevents them from being installed accidentally.
        # See:
        # - https://chaos.social/@hexa/114009069746212598
        # - https://news.ycombinator.com/item?id=43060368
        # - https://github.com/cachix/devenv/pull/1776/files
        devbox = null;
        devenv = null;
        flox = null;
      };
    };
  };

  # ----------------------------------------------------------------------------
  # System-wide Settings
  # ----------------------------------------------------------------------------
  system = {
    # Configure automatic system upgrades.
    autoUpgrade = {
      # Run upgrades weekly.
      dates = "weekly";
      # Allow the system to upgrade without requiring a reboot for the changes to take effect.
      allowReboot = false;
      enable = true;
    };

    # Show a diff of system packages after a successful rebuild.
    # This script uses `dix` to compare the new system configuration with the
    # current one, providing a clear overview of what changed.
    activationScripts.diff = {
      supportsDryActivation = true;
      text = ''
        # Compare the new system derivation ($systemConfig) with the current one.
        ${pkgs.unstable.dix}/bin/dix /run/current-system "$systemConfig"
      '';
    };
  };

  # ----------------------------------------------------------------------------
  # State Version
  #
  # This value determines the NixOS release from which the default
  # settings for stateful data were taken. It‘s crucial to read the
  # NixOS manual before changing this value.
  # ----------------------------------------------------------------------------
  system.stateVersion = "24.11"; # Did you read the comment?

  # --- Manual Upgrade Notes ---
  # sudo nix-channel --add https://nixos.org/channels/nixos-25.05 nixos
  # sudo nix-channel --update
  # sudo nix-channel --list
  # sudo nixos-rebuild switch --upgrade
}
