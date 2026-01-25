# This module defines packages for Ruby development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    ruby # The Ruby programming language
    rubocop
    rubyPackages.erb-formatter # ERB template formatter
  ];
}
