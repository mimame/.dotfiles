# This module defines packages for Bash scripting.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    shellcheck # A static analysis tool for shell scripts
    shfmt # A shell parser, formatter, and interpreter
  ];
}
