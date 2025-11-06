# This module defines packages for Node.js development and tooling.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    nodejs # Node.js runtime
    yarn # Fast, reliable, and secure dependency management
  ];
}
