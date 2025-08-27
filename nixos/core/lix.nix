# https://lix.systems/add-to-config/
{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      inherit (final.lixPackageSets.latest)
        nixpkgs-review
        nix-direnv
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];

  nix.package = pkgs.lixPackageSets.latest.lix;
}
