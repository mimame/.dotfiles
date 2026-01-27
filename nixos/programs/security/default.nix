{ pkgs, ... }:

{
  environment.systemPackages =
    with pkgs;
    [
      age # Modern encryption tool
      sops # SOPS: Secrets OPerationS
    ]
    ++ (with pkgs.unstable; [
      bitwarden-cli # Command-line interface for Bitwarden
      gopass # The standard unix password manager for teams
      gpg-tui # Terminal user interface for GnuPG
      keychain # A manager for ssh-agent and gpg-agent
      libsecret # Library for storing and retrieving passwords and other secrets
      sequoia-sq # Command-line frontend for Sequoia PGP
      vulnix # Vulnerability scanner for Nix expressions and closures
      gitleaks # Scan git repos for secrets
      ripsecrets # Find secrets in source code
    ]);
}
