# This module defines packages for R development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    R # The R programming language
  ];
}
