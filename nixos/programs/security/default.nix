{ pkgs, ... }:

{
  environment.systemPackages = with pkgs.unstable; [
    bitwarden-cli
    gopass
    gpg-tui
    keychain
    libsecret
    sequoia-sq
    vulnix
    gitleaks
    ripsecrets
  ];
}
