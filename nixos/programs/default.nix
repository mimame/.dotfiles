{ ... }:
{
  imports = [
    ./ci-cd.nix
    ./databases.nix
    ./development/default.nix
    ./devops.nix
    ./documents/default.nix
    ./editors/default.nix
    ./file-management/default.nix
    ./git/default.nix
    ./media/default.nix
    ./misc/default.nix
    ./networking/default.nix
    ./services/default.nix
    ./security/default.nix
    ./shells/default.nix
    ./system-tools/default.nix
    ./terminals/default.nix
    ./virtualisation.nix
    ./borgmatic-backup.nix
  ];
}
