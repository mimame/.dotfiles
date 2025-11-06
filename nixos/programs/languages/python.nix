# This module defines packages for Python development and tooling.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    python3 # Python 3 interpreter
    python3Packages.pip # Python package installer
    uv # A fast Python package installer and resolver
  ];
}
