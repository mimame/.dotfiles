# This module defines packages for static site generators.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    hugo # The world’s fastest framework for building websites
    jekyll # A simple, blog-aware, static site generator
    zola # A fast static site generator in a single binary
  ];
}
