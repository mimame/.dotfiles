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
let
  # The configure-gtk script sets the GTK theme, icons, and other appearance-related
  # settings using gsettings. This is necessary because non-GNOME window managers
  # do not have a built-in way to manage these settings.
  #
  # The script is run as a systemd user service after the window manager starts,
  # ensuring that the correct theme is applied at login. It requires the
  # gsettings-desktop-schemas to be available in XDG_DATA_DIRS to find the
  # necessary schemas for the settings it modifies.
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        #!/bin/sh
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        export GTK_THEME="Sweet-Dark"
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema color-scheme prefer-dark
        gsettings set $gnome_schema gtk-theme "Sweet-Dark"
        gsettings set org.gnome.desktop.wm.preferences theme "Sweet-Dark"
        gsettings set $gnome_schema icon-theme "candy-icons"
        gsettings set $gnome_schema cursor-theme "capitaine-cursors-white"
        gsettings set $gnome_schema cursor-size "48"
        gsettings set $gnome_schema document-font-name 'JetBrainsMonoNL 13'
        gsettings set $gnome_schema font-name 'JetBrainsMonoNL 13'
        gsettings set $gnome_schema monospace-font-name 'JetBrainsMonoNL 13'
      '';
  };
in
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

  # Systemd user service to apply GTK settings on login.
  systemd.user.services.configure-gtk = {
    description = "Set GTK theme";
    wantedBy = [ "niri.service" ];
    wants = [ "niri.service" ];
    after = [ "niri.service" ];
    path = [
      pkgs.gsettings-desktop-schemas
      pkgs.unstable.glib # gsettings
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${configure-gtk}/bin/configure-gtk";
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

  # Core GNOME applications and utilities.
  environment.systemPackages =
    with pkgs;
    [ configure-gtk ]
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
