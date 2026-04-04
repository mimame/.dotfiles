# ----------------------------------------------------------------------------
# Security Tools
#
# Encryption, password management, secret scanning, and security auditing.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      # --- Encryption ---
      age # Modern encryption tool (simpler than GPG)
      sops # Secrets OPerationS (encrypted config)
    ]
    ++ (with pkgs.unstable; [
      # --- Password Management ---
      bitwarden-cli # Bitwarden CLI
      gopass # Team password manager (pass-compatible)
      gpg-tui # Terminal UI for GnuPG
      keychain # SSH/GPG agent manager
      libsecret # Password storage library
      sequoia-sq # Command-line for Sequoia PGP

      # --- Security Scanning ---
      vulnix # Nix vulnerability scanner
      gitleaks # Scan git repos for secrets
      ripsecrets # Find secrets in source code
    ]);
}
