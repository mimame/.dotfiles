# This module defines packages for Hare development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    hare # The Hare programming language
    haredoc # Hare's documentation tool
  ];
}
