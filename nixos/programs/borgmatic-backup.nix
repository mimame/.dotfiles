{
  pkgs,
  config,
  lib,
  ...
}:
{
  # To use this backup service, the borg repository must be initialized first.
  # This is a one-time setup step for a new backup drive/location.
  #
  # 1. Make sure the backup drive is mounted at:
  #    /run/media/${config.vars.username}/TOSHIBA_EXT
  #
  # 2. Run the following command to initialize the repository.
  #    Using "repokey-blake2" is recommended for good performance and security.
  #    BORG_PASSPHRASE=mimame borgmatic repo-create --encryption=repokey-blake2 /run/media/${config.vars.username}/TOSHIBA_EXT/backups/borg-narnia-backups

  # We disable the system-wide service to use a user-level one.
  # This allows borgmatic to find the config in ~/.config/borgmatic/config.yaml.
  services.borgmatic.enable = lib.mkForce false;

  environment.systemPackages = [ pkgs.unstable.borgmatic ];

  systemd.user.services.borgmatic = {
    description = "borgmatic backup";
    wantedBy = [ "timers.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      # Lower CPU and I/O priority.
      Nice = 19;
      CPUSchedulingPolicy = "batch";
      IOSchedulingClass = "best-effort";
      IOSchedulingPriority = 7;
      # ExecStart uses systemd-inhibit to prevent sleep/shutdown during backup.
      ExecStart = ''
        ${pkgs.systemd}/bin/systemd-inhibit \
          --who="borgmatic" \
          --what="sleep:shutdown" \
          --why="Prevent interrupting scheduled backup" \
          ${pkgs.unstable.borgmatic}/bin/borgmatic --verbosity -1 --syslog-verbosity 1
      '';
    };
  };

  systemd.user.timers.borgmatic = {
    description = "Run borgmatic backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "3h";
    };
  };
}
