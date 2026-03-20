# This module defines packages for Crystal development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    ameba # A static code analyzer for Crystal
    ameba-ls # Crystal language server powered by Ameba linter
    crystal # The Crystal programming language
    crystalline # Language Server Protocol implementation for Crystal
    shards # Dependency manager for Crystal
  ];
}
