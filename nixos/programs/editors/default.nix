{ pkgs, ... }:

{
  environment.systemPackages = with pkgs.unstable; [
    emacs # Extensible, customizable, free/libre text editor
    # evil-helix
    fresh-editor # Terminal-based text editor with LSP support
    helix # A modal code editor inspired by Neovim and Kakoune
    micro # A modern and intuitive terminal-based text editor
    neovim # A Vim-fork focused on extensibility and usability
  ];
}
