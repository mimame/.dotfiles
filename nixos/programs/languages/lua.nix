# This module defines packages for Lua development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    lua51Packages.jsregexp # JavaScript regular expressions for Lua
    lua51Packages.lua # Lua interpreter
    lua51Packages.luarocks # Lua package manager (for Neovim)
    lua-language-server # Language server for Lua
    stylua # Lua formatter
  ];
}
