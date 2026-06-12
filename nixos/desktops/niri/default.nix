# ----------------------------------------------------------------------------
# Niri Wayland Compositor Configuration
#
# Scrollable-tiling Wayland compositor with explicit portal routing.
# ----------------------------------------------------------------------------
{ pkgs, username, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.unstable.niri;
  };

  # Explicit portal configuration for Niri
  # WHY: The default NixOS Niri module enables portals but doesn't define
  # routing (config.niri). Without this, applications don't know which portal
  # backend to use for screen sharing/file pickers, causing slow startup or hangs.
  # This explicitly prioritizes GNOME portal (required for Niri screencasting)
  # with GTK fallback, ensuring deterministic and reliable behavior.
  xdg.portal.config.niri = {
    default = [
      "gnome" # Required for Niri screencasting
      "gtk"
    ];
  };

  # Display manager configuration
  services.displayManager = {
    # WHY: GDM was crashing with "no session desktop files installed" because the
    # niri.desktop file wasn't being correctly linked into the system path.
    # Explicitly adding the package here ensures GDM can find the session.
    sessionPackages = [ pkgs.unstable.niri ];
    defaultSession = "niri";
    autoLogin = {
      enable = true;
      user = "${username}";
    };
  };

  # Systemd service for automatic disk mounting
  systemd.user.services = {
    udiskie = {
      enable = true;
      description = "Udiskie automounter";
      wantedBy = [ "niri.service" ];
      wants = [ "niri.service" ];
      after = [ "niri.service" ];

      # Fix: Failed to execute child process "notify-send"
      # WHY: udiskie uses notify-send for event hooks. Since systemd user services
      # run in a restricted PATH, we must explicitly provide libnotify.
      # WHY pkgs (Stable): libnotify is a mature tool; stable ensures reliability
      # for core desktop notifications without the churn of the unstable channel.
      path = [ pkgs.libnotify ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.unstable.udiskie}/bin/udiskie --notify --smart-tray --event-hook notify-send";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # Swayidle service to bridge Wayland inactivity events to logind.
    # WHY THIS IS NEEDED ALONGSIDE NIRI AND DMS (DankMaterialShell):
    # 1. DMS has a built-in idle manager (acSuspendTimeout) but it triggers suspend
    #    blindly, without checking active transfers, compile jobs, or SSH sessions.
    # 2. To use the advanced 'autosuspend' daemon instead, DMS's own suspend timeout
    #    must be disabled (set to 0 in settings.json).
    # 3. Under Wayland and Niri, logind does not receive input events directly and
    #    relies on a helper daemon to update the session's IdleHint.
    # 4. Swayidle serves solely as this bridge, updating logind's IdleHint (via loginctl)
    #    after 10 minutes of inactivity so that autosuspend knows when it is safe to
    #    evaluate system load, network bandwidth, and process states before suspending.
    swayidle = {
      enable = true;
      description = "Swayidle daemon to update logind idle state";
      wantedBy = [ "niri.service" ];
      wants = [ "niri.service" ];
      after = [ "niri.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 600 '${pkgs.systemd}/bin/loginctl idle-hint yes' resume '${pkgs.systemd}/bin/loginctl idle-hint no'";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite # XWayland utility for X11 app compatibility on Wayland
    swayidle # Idle management daemon
  ];
}
