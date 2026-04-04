# ----------------------------------------------------------------------------
# Text Editors
#
# Terminal and GUI text editors for code and plain text.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    emacs # Extensible, customizable text editor
    fresh-editor # Terminal editor with LSP support
    helix # Modal editor (Neovim/Kakoune inspired)
    micro # Modern, intuitive terminal editor
    neovim # Vim fork focused on extensibility
  ];
}
