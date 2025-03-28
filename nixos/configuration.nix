# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstableTarball = fetchTarball "https://github.com/nixos/nixpkgs/tarball/nixos-unstable";
in
# nix-alien-pkgs =
#   import (builtins.fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master")
#     { };
{
  nixpkgs.config.permittedInsecurePackages = [
  ];
  imports = [
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    ./boot.nix
    ./firmware.nix
    ./hardware/cpu.nix
    ./hardware/time.nix
    ./hardware/networking.nix
    ./hardware/graphics.nix
    ./lix.nix
    ./base.nix
    ./fonts.nix
    ./base/cli.nix
    ./base/languages_and_lsp.nix
    ./base/devops.nix
    ./base/databases.nix
    ./desktop.nix
    ./laptop.nix
    ./sound.nix
    ./bluetooth.nix
    ./printer.nix
    ./scanner.nix
  ];

  nix = {
    # package = pkgs.nixVersions.latest; # Use lix instead
    # Be sure to run nix-collect-garbage one time per week
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-old";
    };
    settings = {
      # Replace identical files in the nix store with hard links
      auto-optimise-store = true;
      # Unify many different Nix package manager utilities
      # https://nixos.org/manual/nix/stable/command-ref/experimental-commands.html
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };

  nixpkgs.config = {
    # Allow unfree packages
    allowUnfree = true;
    # Add unstable packages injecting directly the unstable channel url
    packageOverrides = pkgs: {
      unstable = import unstableTarball { config = config.nixpkgs.config; };
      # NEVER use devenv package, it containts abusive telemetry, see:
      # https://chaos.social/@hexa/114009069746212598
      # https://news.ycombinator.com/item?id=43060368
      # https://infosec.exchange/@flashfox/114216087400393131
      # https://github.com/cachix/devenv/pull/1776/files
      devenv = null;
    };
  };

  system = {
    # Auto upgrade packages by default without reboot
    autoUpgrade = {
      allowReboot = false;
      enable = true;
      dates = "daily";
    };
    # nixos-rebuild switch
    # nvd shows a beautifully formatted list of the version changes in my system packages
    activationScripts.diff = {
      supportsDryActivation = true;
      text = ''
        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
      '';
    };
  };

  # Be able to execute dynamic linked binaries compiled outside NixOS
  # Needed for `nix-alien-ld` command
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      curl # choosenim
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.unstable.fish;
    users.mimame = {
      isNormalUser = true;
      description = "mimame";
      extraGroups = [
        "audio"
        "incus-admin"
        "input"
        "libvirtd"
        "lxd"
        # "networkmanager"
        "podman"
        "vboxusers"
        "video"
        "wheel"
      ];
      packages = with pkgs; [
        #  firefox
        #  thunderbird
      ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    [

    ]
    ++ (
      with pkgs.unstable;

      [ ]
    );
  # ++ (with nix-alien-pkgs; [
  #   # Run unpatched binaries on Nix/NixOS
  #   nix-alien
  # ]);

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  # sudo nix-channel --add https://nixos.org/channels/nixos-24.11 nixos
  # sudo nix-channel --update
  # sudo nix-channel --list
  # sudo nixos-rebuild switch --upgrade
}
