# This module defines packages for Nix development and tooling.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    nil # Nix Language Server
    nixd # Nix language server
    nixfmt # Official Nix code formatter
    statix # Linter for Nix expressions
    nix-tree # Interactively browse the dependency graph of Nix derivations
    nix-update # Update Nix packages
    nixos-generators # Generate NixOS configurations
  ];
}
