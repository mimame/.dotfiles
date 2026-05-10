# ----------------------------------------------------------------------------
# Nixpkgs Configuration
#
# Configures the nixpkgs package set for all hosts:
# - Overlays the unstable channel as `pkgs.unstable`
# - Nullifies packages with abusive telemetry or undesirable forced features
# - Sets global license and security permissions
# ----------------------------------------------------------------------------
{ config, ... }:
let
  vars = import ../variables.nix;
in
{
  nixpkgs = {
    overlays = [
      (final: prev: {
        unstable = import vars.unstableSrc {
          inherit (config.nixpkgs) config;
          inherit (prev.stdenv.hostPlatform) system;
        };
        # Prevent accidental installation of packages with abusive telemetry
        # or undesirable forced features.
        # See:
        # - https://chaos.social/@hexa/114009069746212598
        # - https://news.ycombinator.com/item?id=43060368
        devbox = null;
        devenv = null;
        flox = null;
      })
    ];

    config = {
      permittedInsecurePackages = [ ];
      allowUnfree = true;
    };
  };
}
