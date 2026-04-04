# ----------------------------------------------------------------------------
# File Management Tools
#
# File explorers, disk usage analyzers, search tools, and file manipulation utilities.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      # --- File Transfer & Remote Access ---
      avfs # Virtual filesystem for archives/remote
      termscp # Terminal file transfer client
    ]
    ++ (with pkgs.unstable; [
      # --- File Explorers & Managers ---
      broot # Navigate and discover filesystem
      clifm # Command-line file manager
      (nnn.override { withNerdIcons = true; }) # File browser with disk usage
      vifm # VI-like file manager
      xplr # Hackable, minimal TUI file explorer
      yazi # Terminal file manager

      # --- Disk Usage Analysis ---
      diskus # Fast disk space analyzer
      dust # Intuitive du alternative
      dua # Disk usage analyzer
      duf # Disk Usage/Free utility
      dysk # Rust du -sh alternative
      erdtree # File tree visualizer with disk usage
      gdu # Fast disk usage analyzer
      ncdu # NCurses disk usage analyzer

      # --- File Search & Manipulation ---
      eza # Modern ls replacement (colors, icons, git)
      fd # Fast, user-friendly find alternative
      fzf # Fuzzy finder
      gomi # Trash can for terminal
      lsd # ls with colors and icons
      massren # Mass file renaming
      ripgrep # Fast recursive grep (regex)
      rnr # Rename files and directories
      scooter # Interactive find and replace
      trash-cli # Command-line trashcan
      tre-command # tree with git awareness
      tree # Directory tree visualizer
    ]);
}
