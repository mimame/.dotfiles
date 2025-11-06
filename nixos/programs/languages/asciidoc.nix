# This module defines packages for AsciiDoc processing.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    asciidoc-full # AsciiDoc processor
    asciidoctor # AsciiDoc processor written in Ruby
  ];
}
