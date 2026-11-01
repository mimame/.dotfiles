# This module defines packages for JSON processing and tooling.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    jq # Command-line JSON processor
  ];
}
