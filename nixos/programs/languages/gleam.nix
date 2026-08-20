# This module defines packages for Gleam development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    gleam # The Gleam programming language
    glas # Language server for Gleam
  ];
}
