# This module defines packages for Markdown processing and tooling.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    markdownlint-cli2 # A fast, flexible, and configurable Markdown linter
    marksman # Markdown language server
    mdbook # A command line tool to create books from Markdown files
    mdl # Markdown lint tool
    inlyne # A fast and feature-rich Markdown viewer
  ];
}
