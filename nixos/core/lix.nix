# ----------------------------------------------------------------------------
# Lix Package Manager Configuration
#
# Lix is a community-driven fork of Nix with faster development cycles.
# See: https://lix.systems/
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # Override Nix-related tools with Lix versions for compatibility
  nixpkgs.overlays = [
    (final: prev: {
      # WHY prev over final: lixPackageSets is part of nixpkgs (present in both
      # final and prev), but using final creates an implicit dependency on
      # overlay evaluation ordering. prev is safer and more idiomatic.
      inherit (prev.lixPackageSets.latest)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
      # NOTE: nix-direnv uses nixpkgs version to avoid evaluation recursion
    })
  ];

  # Use Lix as the primary nix command
  nix.package = pkgs.lixPackageSets.latest.lix;
}
