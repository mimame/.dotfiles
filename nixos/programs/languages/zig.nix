# This module defines packages for Zig development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    zig # The Zig programming language
    zls # Zig Language Server
  ];
}
