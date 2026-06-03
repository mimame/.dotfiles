{
  pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") { },
}:

pkgs.mkShell {
  packages = with pkgs; [
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
}
