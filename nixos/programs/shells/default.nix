# ----------------------------------------------------------------------------
# Shell Utilities
#
# Shell enhancements, prompts, history managers, and alternative shells.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # Direnv: Load environment variables based on current directory
  # WHY nix-direnv: Seamless Nix integration (flake.nix, shell.nix auto-loading)
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  environment.systemPackages = with pkgs.unstable; [
    # --- Shell Enhancements ---
    any-nix-shell # Universal Nix shell experience
    atuin # Modern shell history manager (sync across machines)
    carapace # Command-line argument completer
    carapace-bridge # Bridge for carapace completions
    dura # Automatic git commit background daemon
    mcfly # Neural shell history searcher
    navi # Interactive cheatsheet tool
    starship # Fast, minimal, customizable prompt
    tealdeer # tldr pages (faster man alternative)
    television # Fast fuzzy finder for terminal
    zoxide # Smarter cd command (frecency-based)

    # --- Alternative Shells ---
    nushell # Structured data shell
    xonsh # Python-powered shell
    zsh # Z shell
  ];
}
