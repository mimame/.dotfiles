# This module defines packages for Dart development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    flutter # Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase (includes Dart)
  ];
}
