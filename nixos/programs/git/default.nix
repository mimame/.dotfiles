# ----------------------------------------------------------------------------
# Git & Version Control Tools
#
# Git, GitHub CLI, alternative VCS (jujutsu), diff tools, and Git TUIs.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    # --- Core Git ---
    gitFull # Full Git with all features
    github-cli # GitHub CLI (gh)
    gitoxide # Rust Git implementation (faster for some operations)
    jujutsu # Git-compatible DVCS with better UX
    gg-jj # GUI for the version control system Jujutsu

    # --- Git Extensions ---
    bfg-repo-cleaner # Remove large/sensitive data from repos
    convco # Conventional commits checker
    git-extras # Extra Git commands
    git-filter-repo # Rewrite Git history (filter-branch alternative)
    git-who # Show who changed what

    # --- Diff & Visualization ---
    delta # Syntax-highlighting pager for Git/diff
    difftastic # Structural diff (understands code syntax)
    gfold # Track multiple Git repos
    gitu # Git TUI (Rust)
    gitui # Git TUI (another option)
    onefetch # Git repo summary (like neofetch for Git)

    # --- Git Hooks & Quality ---
    pre-commit # Multi-language pre-commit hook framework
    prek # Fast pre-commit hook manager (Rust)

    # --- Git TUIs ---
    lazygit # Simple terminal UI for Git (most popular)
  ];
}
