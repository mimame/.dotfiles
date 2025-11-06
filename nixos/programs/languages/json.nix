# This module defines packages for JSON processing and tooling.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    nodePackages.vscode-json-languageserver # Language server for JSON
    jsonfmt # JSON formatter
    jq # Command-line JSON processor
  ];
}
