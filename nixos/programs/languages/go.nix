# This module defines packages for Go development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    go # Go programming language compiler and tools
    golangci-lint # A fast Go linters aggregator
    gopls # Go language server
  ];
}
