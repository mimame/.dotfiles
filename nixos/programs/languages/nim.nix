# This module defines packages for Nim development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    nim # The Nim programming language
    nimlangserver # Nim language server implementation (based on nimsuggest)
  ];
}
