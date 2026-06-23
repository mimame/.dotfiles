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
# Uses the `stable` channel consistently for both the daemon and companion
# tools. `stable` still receives updates as new stable versions are released;
# we pin to it permanently because `latest` can introduce unreviewed breakage
# that requires a GRUB rollback to recover from.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  nixpkgs.overlays = [
    # WHY prev over final: lixPackageSets is part of nixpkgs (present in both
    # final and prev), but using final creates an implicit dependency on
    # overlay evaluation ordering. prev is safer and more idiomatic.
    (final: prev: {
      inherit (prev.lixPackageSets.stable)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];

  # The overlay above only adds companion tools — it doesn't change which Nix
  # daemon runs. This line replaces the Nix daemon itself with the Lix build.
  nix.package = pkgs.lixPackageSets.stable.lix;
}
