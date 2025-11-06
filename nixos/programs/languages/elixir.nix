# This module defines packages for Elixir development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    elixir # The Elixir programming language
    elixir-ls # Elixir Language Server
  ];
}
