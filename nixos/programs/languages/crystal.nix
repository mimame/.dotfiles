# This module defines packages for Crystal development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    ameba # A static code analyzer for Crystal
    crystal # The Crystal programming language
    shards # Dependency manager for Crystal
  ];
}
