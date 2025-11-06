{ pkgs, ... }:

{
  # --------------------------------------------------------------------------
  # Direnv Configuration
  #
  # Direnv is a shell extension that loads and unloads environment variables
  # depending on the current directory.
  #
  # - `programs.direnv.enable = true`: Installs direnv and adds the necessary
  #   hook to the shell.
  # - `programs.direnv.nix-direnv.enable = true`: Enables seamless integration
  #   with Nix, allowing direnv to use `flake.nix` or `shell.nix` files to
  #   manage development environments automatically.
  # --------------------------------------------------------------------------
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  environment.systemPackages = with pkgs.unstable; [
    # Shell utilities and enhancements
    any-nix-shell # A universal Nix shell experience
    atuin # A modern shell history manager
    carapace # Command-line argument completer
    carapace-bridge # Bridge for carapace completions
    dura # Keep track of Git repositories in the background
    mcfly # A shell history searcher
    navi # An interactive cheatsheet tool
    starship # The minimal, blazing-fast, and infinitely customizable prompt for any shell!
    tealdeer # A faster, user-friendlier man page alternative
    television # A fast and hackable fuzzy finder for the terminal
    zoxide # A smarter cd command

    # Alternative shells
    nushell # A new type of shell
    xonsh # A Python-powered, cross-platform, Unix-gazing shell
    zsh # Z shell
  ];
}
