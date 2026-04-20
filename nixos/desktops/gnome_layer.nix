# ----------------------------------------------------------------------------
# GNOME Compatibility Layer
#
# Provides essential GNOME services for non-GNOME window managers (Niri, Sway).
# Enables GDM, GNOME Keyring, PolicyKit, GVFS, DConf, and core GNOME apps.
#
# WHY: Even when not running GNOME Shell, many third-party applications
# expect GNOME services to be available for proper integration (file pickers,
# credential storage, settings management, privilege escalation).
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  services = {
    # X11/Xorg required even on Wayland because:
    # 1. GDM is built on X11 infrastructure (even when launching Wayland sessions)
    # 2. Provides XWayland fallback for apps that don't support Wayland
    # 3. NixOS architecture: services.xserver enables essential graphics stack
    #    components that both X11 and Wayland depend on
    xserver.enable = true;
    displayManager.gdm.enable = true;

    gnome = {
      # GNOME Keyring: Secure password/key/certificate storage
      # Essential for auto-storing app passwords, managing SSH keys, WiFi passwords
      gnome-keyring.enable = true;

      # Disable GCR SSH agent: Often fails with ed25519 keys
      # WHY: Repeatedly prompts for passphrase instead of remembering unlocked keys
      # Uses standard NixOS ssh-agent + keychain instead
      gcr-ssh-agent.enable = false;

      # GNOME Settings Daemon: Core desktop functionality
      # Manages keyboard shortcuts, display settings, audio/volume, power management
      gnome-settings-daemon.enable = true;

      # GNOME Online Accounts: Centralized account management
      # Provides unified authentication for Google, Nextcloud, etc.
      gnome-online-accounts.enable = true;
    };

    # GVFS (GNOME Virtual File System): Virtual filesystem layer
    # Provides trash functionality, removable media mounting, network shares (SFTP, SMB)
    gvfs.enable = true;
  };

  # Auto-unlock keyring on GDM login (seamless password management)
  security.pam.services.gdm.enableGnomeKeyring = true;

  programs = {
    seahorse.enable = true; # GUI for keyring management
    ssh.askPassword = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";

    # DConf: GNOME configuration storage system
    # Low-level backend for saving user preferences and application settings
    dconf = {
      enable = true;
      profiles.user.databases = [
        {
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              gtk-theme = "Sweet-Dark";
              icon-theme = "candy-icons";
              cursor-theme = "capitaine-cursors-white";
              cursor-size = pkgs.lib.gvariant.mkUint32 48;
              document-font-name = "Inter 13";
              font-name = "Inter 13";
              monospace-font-name = "Maple Mono NL NF 13";
            };
            "org/gnome/desktop/wm/preferences".theme = "Sweet-Dark";
          };
        }
      ];
    };
  };

  # PolicyKit authentication agent for GUI privilege escalation
  # Provides graphical password dialogs for operations requiring root
  # (mounting drives, installing software, etc.)
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

  # XDG Desktop Portal for Wayland compositors
  # Critical for non-GNOME compositors (Niri) to show:
  # - Standard file picker dialogs
  # - "Open With" dialogs
  # - Screen sharing prompts
  # config.common.default ensures deterministic portal backend selection
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.common.default = [ "gnome" ];
  };

  # Core GNOME applications and theming
  environment.systemPackages =
    with pkgs;
    (with pkgs.unstable; [
      # Core Applications
      baobab # Disk usage analyzer
      file-roller # Archive manager
      gnome-control-center # GNOME settings panel
      gnome-font-viewer # Font viewer
      gparted # Disk partition editor
      gthumb # Image viewer and browser
      loupe # Modern image viewer
      meld # Diff and merge tool
      nautilus # File manager

      # Theming
      candy-icons # Icon theme
      capitaine-cursors # Cursor theme
      sweet # GTK theme (Sweet-Dark)
    ]);
}
