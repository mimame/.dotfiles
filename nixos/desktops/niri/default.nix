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

  # ----------------------------------------------------------------------------
  # Session Startup: greetd (tuigreet prompt) → niri-session
  #
  # WHY GDM IS GONE: Replaces GDM + displayManager.autoLogin (2026-11-04).
  # GDM's autologin stalled 17-230s (measured across boots) between "PAM
  # session opened" and spawning the niri session, with the screen frozen on
  # the boot log — its state machine drags the whole GNOME session stack
  # (accounts-daemon, gnome-session, greeter plumbing) around a session it
  # never displays. greetd's path is PAM → exec.
  #
  # WHY A PASSWORD PROMPT (2026-11-08): dropped initial_session (autologin):
  # tuigreet authenticates via the PAM `login` service, which has
  # enableGnomeKeyring (gnome-services.nix), so the login keyring is unlocked
  # at session start. Autologin left it locked and, with no idle/suspend
  # locker in this setup (only manual Mod+Alt+L → `dms lock`, no swayidle),
  # would let anyone cold-boot straight into the session.
  # NOTE: the passphrase for SSH keys is unrelated to PAM here (plain
  # OpenSSH agent via programs.ssh.startAgent) and is still entered once per
  # session by setup_ssh_agent in fish.
  #
  # niri-session starts niri.service via `systemctl --user --wait`, which
  # preserves graphical-session-pre/graphical-session.target semantics: DMS,
  # portals, udiskie and espanso come up exactly as before.
  # ----------------------------------------------------------------------------
  services.greetd = {
    enable = true;
    settings = {
      # tty1 and every VT / after logout: user pre-selected (--remember),
      # clock shown, password unlocks the keyring, then niri starts.
      # For autologin instead, add:
      #   initial_session = { command = <same>; user = "${username}"; };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${pkgs.unstable.niri}/bin/niri-session";
        user = "greeter";
      };
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

    # No swayidle / idle-triggered suspend.
    # Suspend is manual — `systemctl suspend` or lid close / power key (logind).
    # DMS timeouts are set to 0 in settings.json.
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite # XWayland utility for X11 app compatibility on Wayland
  ];
}
