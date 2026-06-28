# This module defines packages for Elixir development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    beamPackages.elixir # The Elixir programming language
    beamPackages.elixir-ls # Elixir Language Server
  ];
}
