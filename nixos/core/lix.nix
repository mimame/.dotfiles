# ----------------------------------------------------------------------------
# Lix Package Manager Configuration
#
# Lix is a community-driven fork of Nix with faster development cycles.
# See: https://lix.systems/
#
# Emergency recovery: if the current Lix evaluator hangs or fails to build,
# use the default Nix from nixpkgs to evaluate the next generation:
#   nix shell nixpkgs#nix -c sudo nixos-rebuild switch
# If that also hangs, reboot into a previous generation from GRUB.
#
# Uses the official "Advanced change" approach from lix.systems docs:
# - inherit companion tools from lixPackageSets.stable for consistency
# - nixpkgs-review is overridden manually due to self-referential override bug
#   in lixPackageSets.stable (infinite recursion via nix = self.lix)
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      inherit (prev.lixPackageSets.stable)
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
      # nixpkgs-review and nix-direnv have self-referential override bugs in lixPackageSets.stable
      nixpkgs-review = prev.nixpkgs-review.override { nix = prev.lixPackageSets.stable.lix; };
      nix-direnv = prev.nix-direnv.override { nix = prev.lixPackageSets.stable.lix; };
    })
  ];

  nix.package = pkgs.lixPackageSets.stable.lix;
}
