# This module defines packages for Ruby development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    ruby # The Ruby programming language
    ruby-lsp # Language Server Protocol for Ruby
    rubocop
    rubyPackages.erb-formatter # ERB template formatter
  ];
}
