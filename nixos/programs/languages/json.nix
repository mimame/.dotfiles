# This module defines packages for JSON processing and tooling.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    jsonfmt # JSON formatter
    jq # Command-line JSON processor
  ];
}
