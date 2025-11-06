{ pkgs, ... }:

{
  environment.systemPackages = with pkgs.unstable; [
    taplo # TOML toolkit and language server
  ];
}
