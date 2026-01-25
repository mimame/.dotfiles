# This module defines packages for Bash scripting.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    nodePackages.bash-language-server # Language server for Bash
    shellcheck # A static analysis tool for shell scripts
    shfmt # A shell parser, formatter, and interpreter
  ];
}
