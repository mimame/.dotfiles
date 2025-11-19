# This module defines packages for Julia development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    julia # The Julia programming language
  ];
}
