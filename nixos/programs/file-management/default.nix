{ pkgs, ... }:

{
  environment.systemPackages =
    with pkgs;
    [
      # File transfer and remote access
      avfs # A virtual file system that mounts archives and remote filesystems
      termscp # Terminal file transfer and explorer
    ]
    ++ (with pkgs.unstable; [
      # File explorers and managers
      broot # A new way to navigate and discover your filesystem
      clifm # Command line file manager
      (nnn.override { withNerdIcons = true; }) # A file browser and disk usage analyzer
      vifm # VI-like file manager
      xplr # A hackable, minimal, fast TUI file explorer
      yazi # Terminal file manager

      # Disk usage and analysis
      diskus # A free space analyzer
      dust # A more intuitive version of du
      dua # Disk usage analyzer
      duf # Disk Usage Free utility
      dysk # A rust alternative to du -sh
      erdtree # A multi-threaded file tree visualizer and disk usage analyzer
      gdu # Disk usage analyzer
      ncdu # Disk usage analyzer

      # File search and manipulation
      eza # A modern, more feature-rich ls replacement
      fd # A simple, fast and user-friendly alternative to find
      fzf # A command-line fuzzy finder
      gomi # A trash can for your terminal
      lsd # A ls command with a lot of pretty colors and some other stuff
      massren # Mass rename utility
      ripgrep # A line-oriented search tool that recursively searches the current directory for a regex pattern
      rnr # A command-line tool for renaming files and directories
      trash-cli # Command line trashcan
      tre-command # A tree command with git awareness
      tree # List contents of directories in a tree-like format

      # superfile
    ]);
}
