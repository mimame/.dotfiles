# This module provides a GNOME compatibility layer for non-GNOME window managers
# like Niri or Sway. It enables essential GNOME services and features that are
# often required for a complete and functional desktop experience, even when not
# running the full GNOME Shell.
#
# This includes:
# - GDM (GNOME Display Manager) for login management.
# - GNOME Keyring for secure credential storage.
# - PolicyKit for graphical privilege escalation.
# - GVFS for virtual file system access (e.g., trash, network shares).
# - DConf for application settings and theming.
# - Core GNOME applications and utilities.
#
# By enabling these services, this module ensures that both GNOME-native and
# third-party applications integrate smoothly and function as expected.
{ pkgs, ... }:
{
  # X11/Xorg and Display Manager Configuration
  # Even though we're running Wayland, services.xserver is still required because:
  # 1. GDM (GNOME Display Manager) dependency: GDM is built on top of X11
  #    infrastructure, even when it launches Wayland sessions.
  # 2. Backward compatibility and fallback: Provides an X11 fallback session and
  #    enables XWayland for applications that don't support Wayland natively.
  # 3. NixOS architecture: The services.xserver module enables essential graphics
  #    stack components that both X11 and Wayland sessions depend on.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
  };

  # GNOME Keyring daemon - provides secure storage for passwords, keys, and certificates.
  # This is essential for automatically storing and retrieving passwords for applications,
  # managing SSH keys, and storing WiFi passwords.
  services.gnome.gnome-keyring.enable = true;
  # This automatically unlocks the user's keyring when they log in with their password.
  security.pam.services.gdm.enableGnomeKeyring = true;

  # GNOME Seahorse - a GUI for managing passwords and keys stored in the GNOME Keyring.
  programs.seahorse.enable = true;
  # Configure SSH to use Seahorse's graphical password prompt.
  programs.ssh.askPassword = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";

  # PolicyKit Authentication Agent - Essential for privilege escalation in GUI environments.
  # PolicyKit (polkit) is a system-wide authorization framework that controls access to
  # privileged operations like mounting drives or installing software. This service
  # provides the graphical authentication dialog.
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # GNOME Settings Daemon - Core GNOME desktop environment service.
  # This daemon manages essential desktop functionality including keyboard shortcuts,
  # display settings, audio/volume control, and power management.
  services.gnome.gnome-settings-daemon.enable = true;

  # GNOME Online Accounts - Centralized account management service.
  # This service provides unified authentication and integration for online services
  # like Google, Nextcloud, etc.
  services.gnome.gnome-online-accounts.enable = true;

  # GVFS (GNOME Virtual File System) - Virtual filesystem layer for desktop integration.
  # This service provides seamless access to various storage backends and network
  # protocols, including trash functionality, mounting removable media, and accessing
  # network shares (SFTP, SMB).
  services.gvfs.enable = true;

  # DConf - GNOME configuration system backend.
  # DConf is the low-level configuration storage system used by GNOME and GTK applications.
  # It is essential for saving user preferences and application settings.
  programs.dconf.enable = true;

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          "color-scheme" = "prefer-dark";
          "gtk-theme" = "Sweet-Dark";
          "icon-theme" = "candy-icons";
          "cursor-theme" = "capitaine-cursors-white";
          "cursor-size" = pkgs.lib.gvariant.mkUint32 48;
          "document-font-name" = "JetBrainsMonoNL 13";
          "font-name" = "JetBrainsMonoNL 13";
          "monospace-font-name" = "JetBrainsMonoNL 13";
        };
        "org/gnome/desktop/wm/preferences" = {
          "theme" = "Sweet-Dark";
        };
      };
    }
  ];

  # Core GNOME applications and utilities.
  environment.systemPackages =
    with pkgs;
    []
    ++ (with pkgs.unstable; [
      # GNOME Core Applications
      baobab # Disk usage analyzer
      file-roller # Archive manager
      glib # Core application library
      gnome-control-center # GNOME settings panel
      gnome-font-viewer # Font viewer
      gparted # Disk partition editor
      gthumb # Image viewer and browser
      loupe # Image viewer
      meld # Diff and merge tool
      nautilus # File manager

      # Theming and Icons
      candy-icons # Icon theme
      capitaine-cursors # Cursor theme
      sweet # GTK theme
    ]);
}
