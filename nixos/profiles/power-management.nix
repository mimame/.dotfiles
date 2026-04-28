# ----------------------------------------------------------------------------
# Power Management Module
#
# WHY THIS MODULE IS NEEDED:
# 1. Lack of Native Option: The upstream NixOS 'power-profiles-daemon' module
#    lacks a declarative way to set a default profile.
# 2. Declarative Baseline: By default, power-profiles-daemon is imperative;
#    it saves its state in /var/lib/ and persists it across reboots. This
#    module allows us to enforce a "known good" state (like 'balanced')
#    during every system activation, preventing the system from being
#    stuck in 'performance' mode accidentally.
# 3. Automation: Ensures that background tasks (like weekly upgrades) don't
#    trigger extreme thermal behavior if the user forgot to switch back
#    from a high-performance session.
# ----------------------------------------------------------------------------
{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.power-profiles-daemon;
in
{
  options.services.power-profiles-daemon = {
    defaultProfile = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "performance"
          "balanced"
          "power-saver"
        ]
      );
      default = null;
      description = "The power profile to set on system activation.";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.defaultProfile != null) {
    # Set the default power profile during system activation.
    # WHY: power-profiles-daemon persists state in /var/lib/, but this
    # allows us to define a declarative baseline in Nix.
    system.activationScripts.power-profile-default = {
      supportsDryActivation = true;
      text = ''
        # Use powerprofilesctl to set the profile if the daemon is running
        if ${pkgs.systemd}/bin/systemctl is-active --quiet power-profiles-daemon.service; then
          echo "🔋 Setting power profile to ${cfg.defaultProfile}..."
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set ${cfg.defaultProfile}
        fi
      '';
    };

    # Ensure the power-management tools are available
    environment.systemPackages = with pkgs; [
      power-profiles-daemon
    ];
  };
}
