{ pkgs, ... }:

{
  environment.systemPackages = with pkgs.unstable; [
    # Core Git and command-line utilities
    gitFull # Full Git distribution
    github-cli # GitHub CLI
    gitoxide # A pure Rust implementation of Git
    jujutsu # A Git-compatible DVCS

    # Git extensions and helpers
    bfg-repo-cleaner # Tool for removing large or sensitive data from Git repos
    convco # Conventional commits CLI
    git-extras # Git utilities
    git-filter-repo # Tool for rewriting Git history
    git-who # Show who changed what in a Git repo

    # Git diff and visualization tools
    delta # A syntax-highlighting pager for Git, diff, and grep output
    difftastic # A structural diff tool
    gfold # A CLI tool to help you keep track of your Git repositories
    gitu # A Git TUI
    # gitui # A Git TUI
    onefetch # Git repository summary

    # Git hooks and quality tools
    pre-commit # A framework for managing and maintaining multi-language pre-commit hooks
    prek # A fast pre-commit hook manager written in Rust

    # Git GUIs and TUIs
    lazygit # A simple terminal UI for Git commands
  ];
}
