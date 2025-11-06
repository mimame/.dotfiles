{ pkgs, ... }:

{
  environment.systemPackages = with pkgs.unstable; [
    yaml-language-server # Language server for YAML
    yamlfmt # YAML formatter
    yq # Command-line YAML processor
  ];
}
