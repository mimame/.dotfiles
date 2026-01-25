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
    ruff # An extremely fast Python linter
    pyright # Static type checker for Python
    python3Packages.debugpy # An implementation of the Debug Adapter Protocol for Python
  ];
}
