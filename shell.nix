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
    go
    golangci-lint
    commitlint
  ];

  shellHook = ''
    # Isolate Ruby environment to prevent conflicts with local gems
    # Fixes: LoadError: libruby-3.4.8.so.3.4 (mismatch with Nix Ruby 3.4.9)
    export GEM_HOME=$PWD/.nix-gems
    export GEM_PATH=$GEM_HOME
    mkdir -p $GEM_HOME

    echo "❄️  Nix environment (unstable) loaded for .dotfiles development"
    echo "Available tools: prek, treefmt, gitleaks, ripsecrets, golangci-lint, etc."
  '';
}
