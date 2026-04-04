# ----------------------------------------------------------------------------
# Nix Package Manager Configuration
#
# Settings for Nix/Lix package manager including garbage collection, store
# optimization, and experimental features.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # NixOS Helper (nh) - convenient wrapper for nixos-rebuild and garbage collection
  programs.nh = {
    enable = true;
    package = pkgs.unstable.nh;
    clean = {
      enable = true;
      # Keep last 4 days of generations, minimum 3 generations
      extraArgs = "--keep-since 4d --keep 3";
    };
  };

  # Enable nix-index for finding which package provides a file
  programs.nix-index.enable = true;

  nix.settings = {
    # Optimize store by hard-linking identical files
    auto-optimise-store = true;

    # Enable modern Nix features
    experimental-features = [
      "nix-command" # New nix CLI (nix build, nix run, etc.)
      "flakes" # Reproducible, composable project management
    ];

    # Allow wheel group to use restricted features without root
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  # Automatic garbage collection disabled - use `nh clean` for control
  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   options = "--delete-old";
  # };
}
