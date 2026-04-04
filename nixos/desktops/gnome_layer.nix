# ----------------------------------------------------------------------------
# GNOME Compatibility Layer
#
# Provides essential GNOME services for non-GNOME window managers (Niri, Sway).
# Enables GDM, GNOME Keyring, PolicyKit, GVFS, DConf, and core GNOME apps.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  services = {
    # X11/Xorg required for GDM and XWayland fallback
    xserver.enable = true;
    displayManager.gdm.enable = true;

    gnome = {
      gnome-keyring.enable = true; # Secure password/key storage
      gcr-ssh-agent.enable = false; # Disabled (fails with ed25519 keys)
      gnome-settings-daemon.enable = true; # Desktop functionality (keyboard, display, audio)
      gnome-online-accounts.enable = true; # Unified online account management
    };

    gvfs.enable = true; # Virtual filesystem (trash, network shares, removable media)
  };

  # Auto-unlock keyring on GDM login
  security.pam.services.gdm.enableGnomeKeyring = true;

  programs = {
    seahorse.enable = true; # GUI for keyring management
    ssh.askPassword = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";

    # DConf for application settings and theming
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
              document-font-name = "Maple Mono NL NF 13";
              font-name = "Maple Mono NL NF 13";
              monospace-font-name = "Maple Mono NL NF 13";
            };
            "org/gnome/desktop/wm/preferences".theme = "Sweet-Dark";
          };
        }
      ];
    };
  };

  # PolicyKit authentication agent for GUI privilege escalation
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

  # XDG Desktop Portal for file pickers, screen sharing in Wayland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.common.default = [ "gnome" ]; # Critical for Niri/non-GNOME compositors
  };

  # Core GNOME applications and theming
  environment.systemPackages =
    with pkgs;
    (with pkgs.unstable; [
      # Core Applications
      baobab
      file-roller
      gnome-control-center
      gnome-font-viewer
      gparted
      gthumb
      loupe
      meld
      nautilus

      # Theming
      candy-icons
      capitaine-cursors
      sweet
    ]);
}
