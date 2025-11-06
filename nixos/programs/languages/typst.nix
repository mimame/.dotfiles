{ pkgs, ... }:

{
  environment.systemPackages = with pkgs.unstable; [
    tinymist # A language server for Typst
    typst # A new markup-based typesetting system
    typstyle # A formatter for Typst
  ];
}
