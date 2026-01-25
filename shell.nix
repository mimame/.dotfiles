{
  pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") { },
}:

pkgs.mkShell {
  # These are the packages required for the project's quality assurance suite (prek).
  # Using a shell.nix file allows for better caching in CI and a consistent
  # environment for local development.
  # This shell specifically uses the nixos-unstable channel.
  buildInputs = with pkgs; [
    # Core framework
    prek

    # Security tools
    ripsecrets
    gitleaks

    # Formatting and Linting (used by treefmt and actionlint)
    treefmt
    nixfmt
    fish
    stylua
    taplo
    jaq
    statix
    yamlfmt
    jsonfmt
    actionlint
    rubocop
    commitlint
  ];

  shellHook = ''
    echo "❄️  Nix environment (unstable) loaded for .dotfiles development"
    echo "Available tools: prek, treefmt, gitleaks, ripsecrets, rubocop, etc."
  '';
}
