# ----------------------------------------------------------------------------
# Laptop Power Management Profile
#
# Configures power management, input devices, and essential utilities for laptops.
#
# Power Strategy:
# - Autosuspend handles idle detection with real activity awareness:
#     - Blocks suspend while download/backup/transfer processes are running
#       (rsync, borg, borgmatic, wget, curl, wget2, aria2c, scp, rclone, dd, nix, ffmpeg, mosh-server)
#     - Blocks suspend while network bandwidth exceeds 1 KB/s
#     - Blocks suspend while system load is above 0.5 (covers any unlisted
#       CPU/IO-intensive work: compilation, ffmpeg, nix build, etc.)
#     - Blocks suspend while SSH connections are active
#     - Suspends after 10 min of true idle (no user input + all checks clear)
# - Suspend-then-hibernate: after 2h in suspend the system hibernates
# - Lid close / power key: handled directly by logind, bypasses idle checks
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  services = {
    # systemd-logind: lid and power key behavior only.
    # Idle suspension is delegated entirely to autosuspend below.
    # See: https://www.freedesktop.org/software/systemd/man/latest/logind.conf.html
    logind.settings.Login = {
      # Suspend-then-hibernate on lid close regardless of power source.
      # WHY: if the laptop is left plugged in and then loses power (e.g. outage),
      # it safely hibernates after 2h instead of draining the battery to zero.
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "suspend-then-hibernate";
      HandlePowerKey = "suspend";
      HandlePowerKeyLongPress = "poweroff";
      # Idle action disabled: autosuspend owns idle-triggered suspension.
      IdleAction = "ignore";
      # "no" = respect inhibitor locks on lid close. If the lid is closed while
      # an inhibitor is active, logind skips the action. When the inhibitor
      # releases, logind does NOT re-fire the event — autosuspend picks up
      # from there once the system goes idle.
      LidSwitchIgnoreInhibited = "no";
    };

    # Touchpad configuration (may be overridden by compositor)
    # See: https://wayland.freedesktop.org/libinput/doc/latest/clickpad-softbuttons.html
    libinput = {
      enable = true;
      touchpad = {
        clickMethod = "clickfinger"; # Two-finger right-click, three-finger middle-click
        disableWhileTyping = true;
        middleEmulation = false;
        naturalScrolling = true;
        tappingButtonMap = "lrm"; # One-finger left, two-finger right, three-finger middle
        tapping = true;
      };
    };

    # Fingerprint authentication support (for DMS Shell)
    fprintd.enable = true;

    # Activity-aware idle suspension.
    # Unlike logind's dumb timer, autosuspend checks for real background work
    # before suspending. All checks must clear simultaneously for idle_time
    # seconds before the system is actually suspended.
    # See: https://autosuspend.readthedocs.io
    autosuspend = {
      enable = true;

      # Maps to the [general] INI section. All checks are enabled by default.
      settings = {
        interval = 30; # Check activity every 30s
        # Grace period after all checks clear. LogindSessionsIdle provides
        # the main 10-min window; this just avoids a race on check boundaries.
        idle_time = 30;
        suspend_cmd = "systemctl suspend-then-hibernate";
      };

      # Each entry maps to a [check.<name>] INI section.
      # enabled = true is the module default; only set it to disable a check.
      checks = {
        # Block suspend if the user has been active recently (Wayland-compatible).
        # idle_time here is the logind session inactivity threshold.
        LogindSessionsIdle.idle_time = 600; # 10 min without keyboard/mouse input

        # Block suspend while any of these processes are running.
        # - borg: the binary borgmatic actually invokes for backup I/O
        # - nix: store fetches and copies (builds caught by Load check)
        # - scp/rclone: transfers not reflected in NetworkBandwidth alone
        # - dd: disk imaging; wget/curl/wget2/aria2c: explicit download tools
        # - ffmpeg: copy/remux (-c copy) is near-zero CPU, Load won't catch it
        # - mosh-server: mosh switches to UDP after SSH handshake, so
        #   ActiveConnection on port 22 misses active mosh sessions
        # cp omitted: brief system copies aren't worth blocking; large ones
        # raise load above the Load threshold below.
        Processes.processes = "rsync borgmatic borg wget curl wget2 aria2c scp rclone dd nix ffmpeg mosh-server";

        # Block suspend while the network is actively transferring data.
        # 1 KB/s avoids false positives from keepalives, NTP, and DNS traffic
        # while still catching any meaningful download or upload.
        NetworkBandwidth = {
          threshold_send = 1024; # bytes/s
          threshold_receive = 1024; # bytes/s
        };

        # Block suspend while the system is under load.
        # Catches anything CPU/IO-intensive not in the process list:
        # compilation, ffmpeg, nix build, scientific computing, large copies, etc.
        # Threshold is the raw 5-min load average (not normalized per core).
        Load.threshold = 0.5;

        # Block suspend while SSH connections are active.
        # Prevents cutting off remote sessions mid-work.
        ActiveConnection.ports = 22;
      };
    };
  };

  # systemd-sleep: hibernate after 2h in suspend.
  # Applies to all suspend paths (autosuspend idle, lid close, power key).
  # See: https://www.freedesktop.org/software/systemd/man/latest/sleep.conf.d.html
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=yes
    HibernateDelaySec=2h
  '';

  environment.systemPackages = with pkgs; [
    brightnessctl # Screen brightness control
    libinput # Input device diagnostics/config
    libinput-gestures # Touchpad gesture support
  ];
}
