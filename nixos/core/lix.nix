# ----------------------------------------------------------------------------
# Lix Configuration
#
# This file configures the system to use Lix, a community-driven fork of the
# Nix package manager. Lix aims for a faster development cycle and incorporates
# community-contributed features more quickly than the official Nix project.
#
# For more information, visit: https://lix.systems/
# To add Lix to your configuration, see: https://lix.systems/add-to-config/
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # This overlay ensures that specific Nix-related tools are taken from the
  # Lix package set. This is important for maintaining compatibility and
  # ensuring that the entire toolchain works seamlessly with Lix.
  nixpkgs.overlays = [
    (final: prev: {
      # The `inherit` statement pulls these packages from the `lixPackageSets.latest`
      # attribute set, overriding the default Nixpkgs versions.
      inherit (final.lixPackageSets.latest)
        nixpkgs-review # A tool for reviewing Nixpkgs pull requests.
        nix-direnv # Integration for Nix and direnv.
        nix-eval-jobs # A tool for evaluating Nix expressions in parallel.
        nix-fast-build # A faster Nix builder.
        colmena # A NixOS deployment tool.
        ;
    })
  ];

  # This setting replaces the default Nix package with Lix.
  # `pkgs.lixPackageSets.latest.lix` points to the latest available version
  # of Lix, making it the primary `nix` command on the system.
  nix.package = pkgs.lixPackageSets.latest.lix;
}
