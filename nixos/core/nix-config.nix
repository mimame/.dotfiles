{ pkgs, ... }:
{
  # ----------------------------------------------------------------------------
  # NixOS System Rebuild Configuration
  # ----------------------------------------------------------------------------
  # Use the experimental 'ng' backend for `nixos-rebuild`.
  # This is expected to become the default in future NixOS versions.
  # TODO: Remove this option after NixOS 25.11, when it's likely to be the default.
  system.rebuild.enableNg = true;

  # ----------------------------------------------------------------------------
  # NixOS Helper (nh)
  #
  # `nh` is a utility for managing NixOS systems, providing a convenient
  # wrapper around common commands like `nixos-rebuild` and `nix-collect-garbage`.
  # ----------------------------------------------------------------------------
  programs.nh = {
    enable = true;
    # Use the latest version of `nh` from the unstable channel for new features.
    package = pkgs.unstable.nh;
    # Configure `nh` to automatically clean old system generations.
    clean.enable = true;
    # Keep generations from the last 4 days, but always maintain at least 3 generations.
    # This prevents accidental deletion of recent, potentially good, configurations.
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  # ----------------------------------------------------------------------------
  # Nix Package Manager Configuration
  # ----------------------------------------------------------------------------
  nix = {
    # The primary Nix package is set to Lix in `core/lix.nix`.
    # package = pkgs.nixVersions.latest;

    # Automatic garbage collection is disabled.
    # Instead, `nh clean` or manual `nix-collect-garbage` is preferred for more
    # control over when old generations are deleted.
    # gc = {
    #   automatic = true;
    #   persistent = true;
    #   dates = "weekly";
    #   options = "--delete-old";
    # };

    settings = {
      # Optimize the Nix store by replacing identical files with hard links.
      # This significantly reduces disk space usage over time.
      auto-optimise-store = true;

      # Enable experimental features for modern Nix workflows.
      # - `nix-command`: Provides the unified `nix` CLI (e.g., `nix build`, `nix run`).
      # - `flakes`: Enables a reproducible, composable way to manage Nix projects.
      # See: https://nixos.org/manual/nix/stable/command-ref/experimental-commands.html
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Allow users in the 'wheel' group (typically administrators) to use
      # restricted Nix features without being root. This is necessary for
      # tasks like building flakes from local paths or using impure features.
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };

}
