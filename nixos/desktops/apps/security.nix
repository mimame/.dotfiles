{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    # Password management
    bitwarden-desktop # Desktop password manager
    keepassxc # Cross-platform password manager
  ];
}
