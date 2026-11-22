# ----------------------------------------------------------------------------
# Nix Package Manager Configuration
#
# Settings for Nix/Lix package manager including garbage collection, store
# optimization, and experimental features.
# ----------------------------------------------------------------------------
{ lib, pkgs, ... }:
{
  programs = {
    # NixOS Helper (nh): convenient wrapper for nixos-rebuild and garbage
    # collection. Disabled deliberately.
    #
    # WHY: the `nh-clean` timer and `system.autoUpgrade` were both weekly at
    # the same instant. `nh clean all` runs `nix gc --optimise`, and the
    # concurrent GC and evaluation corrupted the store: live `.drv` files
    # were deleted, leaving DB rows that point at nothing, and base paths
    # (linux-modules, glibc-bin, python3, gcc, webkitgtk) were left with
    # content that no longer matches its recorded hash. A rebuild then dies:
    #
    #   error: opening '/nix/store/…-source.drv': No such file or directory
    #
    # Fix: `nh` is removed from config. Nothing that writes to the store runs
    # on a timer: `nix.gc.automatic = false` (bottom of this file) and
    # `system.autoUpgrade` is disabled in `hosts/narnia/configuration.nix`.
    # GC, channel update and rebuild are manual and never overlap.
    #
    # Recovery. A half-corrupt store has two distinct classes with different
    # fixes:
    #
    # A. Modified CONTENT. A valid path whose bytes no longer match its
    #    recorded hash (`was modified!`, `Truncated zstd input`, a missing
    #    `.so` like `libattr.so.1` at build time). Repairs with:
    #      sudo nix-store --verify --check-contents --repair
    #    Re-downloads the affected paths from cache.nixos.org. The `nix store
    #    verify --all --repair` CLI form reports but does not repair; it does
    #    not fix these cases.
    #
    # B. A deleted path still in the database, with dead referrers: dangling
    #    `.drv` rows left by the interrupted GC. Find them and who holds them:
    #      sudo nix-store --verify --check-contents 2>&1 | grep disappeared
    #      sudo nix-store --query --referrers <path>
    #    Delete the whole dead chain, the referrers first, with:
    #      sudo nix-store --delete --ignore-liveness --store local <path>…
    #    `--store local` is mandatory: the Lix daemon refuses `repairPath`
    #    and `--ignore-liveness` outright.
    #    Caution: during a rebuild the toplevel's paths are not yet under
    #    /run/current-system, so a referrer missing from
    #    `--requisites /run/current-system` is not proof it is dead; it may
    #    be live in the build in flight. Repair content (A) before deleting
    #    anything; most stores only need A.
    #
    # Manual maintenance order, once the store is clean:
    #   sudo nix-collect-garbage --delete-older-than 14d
    #   sudo nix-channel --update
    #   sudo nixos-rebuild build
    #   sudo nixos-rebuild switch
    #
    # Never loop `nixos-rebuild build --upgrade` while repairing: `--upgrade`
    # re-fetches the channel, re-rolls the store paths the toplevel references,
    # and every failed attempt surfaces another broken path. Get class A clean,
    # then build without `--upgrade`, then update the channel as its own step.
    #
    # nh = {
    #   enable = true;
    #   package = pkgs.unstable.nh;
    #   clean = {
    #     enable = true;
    #     # Keep last 4 days of generations, minimum 3 generations
    #     extraArgs = "--keep-since 4d --keep 3";
    #   };
    # };

    # nix-index replaces command-not-found: uses a live-built index of the
    # current nixpkgs tree instead of a stale static database. The two
    # cannot coexist because they both register the command-not-found handler.
    command-not-found.enable = false;
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  nix = {
    # Build Priority and Resource Limits
    # Slower builds, but reliable and allows comfortable use in the background
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

    settings = {
      # Optimize store by hard-linking identical files
      auto-optimise-store = true;

      # Official NixOS defaults (can be overridden by host-specific configs)
      max-jobs = lib.mkDefault "auto";
      cores = lib.mkDefault 0;

      # Enable modern Nix features
      experimental-features = [
        "nix-command" # New nix CLI (nix build, nix run, etc.)
        "flakes" # Reproducible, composable project management
      ];

      # Allow wheel group to use restricted features without root
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };

  # No automatic timers. The only guarantee against the race condition that
  # corrupted the store is: never let two processes that write to the store
  # run at the same time. With no timers, neither the GC nor an update ever
  # starts on its own; everything is manual, synchronous and in order.
  #
  # When you want to update + clean up, run in order:
  #   sudo nix-collect-garbage --delete-older-than 14d
  #   sudo nix-channel --update
  #   sudo nixos-rebuild build
  #   sudo nixos-rebuild switch
  #
  # Keep the timer settings commented as a reference if you ever re-enable
  # automated GC; if you do, make sure `system.autoUpgrade` stays disabled,
  # or you recreate the same race.
  #
  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   options = "--delete-older-than 14d";
  # };
  nix.gc.automatic = false;
}
