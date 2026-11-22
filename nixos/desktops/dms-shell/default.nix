# ----------------------------------------------------------------------------
# DMS-Shell Configuration
#
# Desktop Management System Shell for Niri with self-healing capabilities.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  programs.dms-shell = {
    enable = true;
    package = pkgs.unstable.dms-shell;
    quickshell.package = pkgs.unstable.quickshell;
  };

  # Self-healing configuration for DMS-Shell
  # WHY: DMS-Shell can crash or be terminated during:
  # - NixOS switches (service restarts)
  # - Input device changes (evdev errors)
  # Systemd automatically restarts it with a 3s delay for D-Bus/Portals to settle
  systemd.user.services.dms = {
    serviceConfig = {
      Restart = "always";
      RestartSec = "3s"; # Allow D-Bus/Portals time to settle
    };
    unitConfig = {
      PartOf = [ "graphical-session.target" ];
      StartLimitIntervalSec = "60s";
      StartLimitBurst = 5;
    };
  };

  # WHY: dms doctor requirements documented per package below.
  # kdePackages.qtbase is the one judgment call: it lands qmake/qtpaths in the
  # system profile only so `dms doctor` can verify the Qt6 gtk3 platform theme
  # plugin against the path Qt actually searches. The plugin (libqgtk3.so) is
  # already inside every Qt6 app's closure and theming works without it
  # (QT_QPA_PLATFORMTHEME=gtk3 is exported by niri/config.kdl). Dropping this
  # line changes nothing functionally; doctor reverts to "Cannot verify".
  environment.systemPackages = with pkgs; [
    # --- Dux Labs apps (Quickshell-based, pair with dms-shell) ---
    unstable.dux-calendar # Local/Google/Microsoft/CalDAV calendar app
    unstable.dux-files # File manager for Wayland built with Quickshell and Go
    unstable.dux-search # Filesystem search with fuzzy matching; replaces dsearch, renamed in the Dux 2.x rebrand

    # --- dms doctor requirements ---
    unstable.adw-gtk3 # GTK3 dynamic theming; without it DMS falls back to a global CSS override
    unstable.kdePackages.qtbase # qtpaths/qmake so dms doctor can verify the Qt6 gtk3 platform theme plugin
  ];
}
