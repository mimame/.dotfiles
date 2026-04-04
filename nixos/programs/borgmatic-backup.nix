# ----------------------------------------------------------------------------
# Borgmatic Backup Service
#
# Automated encrypted backups with borgbackup + borgmatic.
# Runs as user service (not system-wide) to access ~/.config/borgmatic/config.yaml
# ----------------------------------------------------------------------------
{
  pkgs,
  config,
  lib,
  ...
}:
{
  # Disable system-wide service to use user-level one
  # WHY: User service can access ~/.config/borgmatic/config.yaml
  services.borgmatic.enable = lib.mkForce false;

  environment.systemPackages = [ pkgs.unstable.borgmatic ];

  # User-level systemd service
  systemd.user.services.borgmatic = {
    description = "borgmatic backup";
    wantedBy = [ "timers.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      # Low priority to avoid impacting system performance
      Nice = 19; # Lowest CPU priority
      CPUSchedulingPolicy = "batch"; # Batch scheduling
      IOSchedulingClass = "best-effort"; # Lowest I/O priority
      IOSchedulingPriority = 7;
      # systemd-inhibit prevents sleep/shutdown during backup
      # WHY: Prevents data corruption from interrupted backups
      ExecStart = ''
        ${pkgs.systemd}/bin/systemd-inhibit \
          --who="borgmatic" \
          --what="sleep:shutdown" \
          --why="Prevent interrupting scheduled backup" \
          ${pkgs.unstable.borgmatic}/bin/borgmatic --verbosity -1 --syslog-verbosity 1
      '';
    };
  };

  # Daily backup timer with randomized delay
  # WHY RandomizedDelaySec: Avoids backup storms if multiple machines sync to same schedule
  systemd.user.timers.borgmatic = {
    description = "Run borgmatic backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true; # Run missed backups on boot
      RandomizedDelaySec = "3h"; # Random 0-3h delay
    };
  };

  # --- First-Time Setup ---
  # 1. Mount backup drive at:
  #    /run/media/${config.vars.username}/TOSHIBA_EXT
  #
  # 2. Initialize the repository (one-time):
  #    BORG_PASSPHRASE=mimame borgmatic repo-create \
  #      --encryption=repokey-blake2 \
  #      /run/media/${config.vars.username}/TOSHIBA_EXT/backups/borg-narnia-backups
  #
  # 3. Configure ~/.config/borgmatic/config.yaml with backup paths
}
