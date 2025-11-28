{ pkgs, vars, ... }:
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
    (import ./services/default.nix {
      inherit pkgs;
      inherit (vars) username;
    })
    ./security/default.nix
    ./shells/default.nix
    ./system-tools/default.nix
    ./terminals/default.nix
    (import ./virtualisation.nix {
      inherit pkgs;
      inherit (vars) username;
    })
    (import ./borgmatic-backup.nix {
      inherit pkgs vars;
    })
  ];
}
