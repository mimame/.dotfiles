{ pkgs, ... }:
let
  nix-alien-pkgs =
    import (builtins.fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master")
      { };
in
{

  # Execute shebangs on NixOS that assume hard coded locations in locations like /bin or /usr/bin etc
  services.envfs.enable = true;

  # Be able to execute dynamic linked binaries compiled outside NixOS
  # Needed for `nix-alien-ld` command
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      curl
    ];
  };

  environment.systemPackages = with nix-alien-pkgs; [
    nix-alien
  ];
}
