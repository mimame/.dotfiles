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
  config, # The aggregated configuration of all imported modules.
  pkgs, # The default Nixpkgs package set.
  vars, # The set of variables from variables.nix
  ... # Catch-all for other arguments (e.g., `lib`, `modulesPath`).
}:
let
  # Fetch the nixpkgs-unstable channel as a tarball. This allows access to
  # bleeding-edge packages without needing to manage system-wide channels
  # imperatively with `nix-channel`.
  unstableTarball = fetchTarball "https://github.com/nixos/nixpkgs/tarball/nixos-unstable";
in
{
  # A list of insecure packages that are explicitly allowed to be installed.
  # This should be used with caution.
  nixpkgs.config.permittedInsecurePackages = [
  ];

  # ----------------------------------------------------------------------------
  # Modular Imports
  #
  # This section imports various modular components that define the system's
  # behavior, hardware support, user environments, and installed programs.
  # Paths use `../../` to refer to modules in the parent `nixos` directory.
  # ----------------------------------------------------------------------------
  imports = [
    # Automatically generated hardware configuration.
    # This file is typically located at `/etc/nixos/hardware-configuration.nix`
    # and contains hardware-specific settings detected during installation.
    ./hardware-configuration.nix

    # --- Core System Configuration ---
    ../../core/boot.nix
    ../../core/firmware.nix
    ../../core/lix.nix
    ../../core/nix-config.nix
    ../../core/posix-compatibility.nix

    # --- Hardware Support ---
    ../../hardware/cpu.nix
    ../../hardware/time.nix

    # Networking configuration, passed the hostname for host-specific settings.
    (import ../../hardware/networking.nix {
      inherit config pkgs;
      inherit (vars) hostname;
    })
    ../../hardware/graphics.nix
    ../../hardware/bluetooth.nix
    ../../hardware/sound.nix
    ../../hardware/peripherals/printer.nix
    ../../hardware/peripherals/scanner.nix

    # --- Device-Specific Profiles ---
    # Example: Profile for laptop-specific settings.
    ../../profiles/laptop.nix

    # --- Base System Services & Settings ---

    (import ../../system/base.nix {
      inherit pkgs;
      inherit (vars) username;
    })
    ../../system/btrfs.nix
    ../../system/fonts.nix

    # --- Programs & Development Environments ---
    (import ../../programs/cli.nix {
      inherit pkgs;
      inherit (vars) username;
    })
    ../../programs/languages_and_lsp.nix
    (import ../../programs/virtualisation.nix {
      inherit pkgs;
      inherit (vars) username;
    })
    ../../programs/ci-cd.nix
    ../../programs/devops.nix
    ../../programs/databases.nix
    ../../programs/pdf.nix

    # --- User Accounts ---
    (import ../../users/${vars.username}/default.nix {
      inherit pkgs;
      inherit (vars) username;
    })

    # --- Desktop Environment ---
    ../../desktops/base.nix
    ../../desktops/gnome_layer.nix
    # ./desktop/sway.nix
    (import ../../desktops/${vars.desktop}/default.nix {
      inherit pkgs;
      inherit (vars) username;
    })
    # ./desktop/cosmic.nix
  ];

  # ----------------------------------------------------------------------------
  # Nixpkgs Configuration
  # ----------------------------------------------------------------------------
  nixpkgs.config = {
    # Allow the installation of packages with non-free licenses.
    allowUnfree = true;

    # Use an overlay to add the `unstable` package set, making it available
    # as `pkgs.unstable`.
    packageOverrides = pkgs: {
      unstable = import unstableTarball { inherit (config.nixpkgs) config; };

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
  # System-wide Packages
  #
  # Packages installed here are available to all users.
  # To search for packages, run: $ nix search wget
  # ----------------------------------------------------------------------------
  environment.systemPackages =
    with pkgs;
    (with pkgs.unstable; [
      # e.g. btop
    ]);

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
