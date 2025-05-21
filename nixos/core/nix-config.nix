{ ... }:
{

  # TODO: Remove after 25.11
  system.rebuild.enableNg = true;

  nix = {
    # package = pkgs.nixVersions.latest; # Use lix instead
    # Be sure to run nix-collect-garbage one time per week
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-old";
    };
    settings = {
      # Replace identical files in the nix store with hard links
      auto-optimise-store = true;
      # Unify many different Nix package manager utilities
      # https://nixos.org/manual/nix/stable/command-ref/experimental-commands.html
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };

}
