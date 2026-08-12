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
{
  pkgs,
  ...
}:
let
  whitesur = pkgs.unstable.whitesur-gtk-theme.override {
    colorVariants = [ "dark" ];
    themeVariants = [ "purple" ];
  };
  themeName = "WhiteSur-Dark-purple";
  gresource = "${pkgs.glib.dev}/bin/gresource";
in
{
  services = {
    # GDM (GNOME Display Manager) is the preferred manager for this setup
    # because it integrates seamlessly with GNOME services (Keyring, Settings Management)
    # and handles auto-unlocking. It runs natively on Wayland.
    displayManager.gdm.enable = true;

    gnome = {
      # GNOME Keyring: Secure password/key/certificate storage
      # Essential for auto-storing app passwords, managing SSH keys, WiFi passwords
      gnome-keyring.enable = true;

      # Disable GCR SSH agent: Often fails with ed25519 keys
      # WHY: Repeatedly prompts for passphrase instead of remembering unlocked keys
      # Uses standard NixOS ssh-agent + keychain instead
      gcr-ssh-agent.enable = false;

      # GNOME Settings Daemon: The backbone of GNOME's services.
      # Essential for managing UI state, keyboard shortcuts, display settings,
      # and hardware integration in Wayland sessions.
      gnome-settings-daemon.enable = true;

      # Centralized account management (Google, Nextcloud, etc.)
      # Disabled by default to reduce background overhead as it's rarely used.
      gnome-online-accounts.enable = false;
    };

    # GVFS (GNOME Virtual File System): Virtual filesystem layer
    # Provides trash functionality, removable media mounting, network shares (SFTP, SMB)
    gvfs.enable = true;
  };

  # Auto-unlock keyring on GDM and TTY login (seamless password management)
  # - gdm: Handles unlocking for GUI logins via the display manager.
  # - login: Handles unlocking for TTY logins or when the GDM session doesn't
  #   automatically propagate login credentials to the keyring agent.
  # Enabling both ensures passwordless auth for apps regardless of how the user logs in.
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # libadwaita (GTK4 >= 4.10) ignores `gtk-theme-name` and `GTK_THEME`.
  # Setting GTK_THEME=WhiteSur-Dark forces GTK4 to load
  # share/themes/WhiteSur-Dark/gtk-4.0/gtk.css — whose only content is
  # `@import url("resource:///org/gnome/theme/gtk.css")`. That gresource is
  # NOT auto-registered for libadwaita apps, so the import silently fails
  # (`Theme parser error: gtk.css:1:1-52: Failed to import ...`), dropping
  # the entire theme. GTK3 + non-libadwaita GTK4 apps still work via
  # settings.ini/gsettings because their theme loader registers the gresource.
  # Flat CSS + assets for libadwaita are installed by userActivationScripts
  # below.

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
              gtk-theme = themeName;
              icon-theme = "WhiteSur-dark";
              cursor-theme = "WhiteSur-cursors";
              cursor-size = pkgs.lib.gvariant.mkUint32 48;
              document-font-name = "Inter 13";
              font-name = "Inter 13";
              monospace-font-name = "Maple Mono NL NF 13";
            };
            "org/gnome/desktop/wm/preferences".theme = themeName;
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
      whitesur-cursors # Cursor theme
      whitesur # GTK theme (WhiteSur-Dark) — see libadwaita activation script below
      whitesur-icon-theme
    ]);

  # Global GTK settings to ensure consistency across applications.
  # WHY:
  # - GTK 3/4: We explicitly define settings.ini in /etc/ to provide a reliable
  #   system-wide fallback for non-GNOME-aware applications.
  # - GTK 2: Omitted as it is officially deprecated. Modern applications (GTK 3/4)
  #   do not require GTK 2 configurations, and providing them often causes
  #   conflicts or reverts to legacy Noto fonts. DConf handles modern styling.
  environment.etc = {
    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${themeName}
      gtk-icon-theme-name=WhiteSur-dark
      gtk-font-name=Inter 13
    '';
    "gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${themeName}
      gtk-icon-theme-name=WhiteSur-dark
      gtk-font-name=Inter 13
    '';
  };

  # Install WhiteSur as a flat CSS overlay for libadwaita apps.
  # WHY: libadwaita apps (Nautilus, Loupe, Papers, ...) ignore
  # `gtk-theme-name` and load the user `~/.config/gtk-4.0/gtk.css`
  # overlay instead. The WhiteSur nixpkg ships
  # `share/themes/WhiteSur-Dark/gtk-4.0/gtk.gresource` (which GTK4's
  # loader registers for non-libadwaita apps) but does NOT produce
  # the self-contained flat CSS that libadwaita needs.
  # Here we use `gresource extract` to pull the compiled stylesheet
  # and assets out of the gresource bundle into `~/.config/gtk-4.0/`,
  # matching what upstream's `install.sh -l` does at install time.
  # Idempotent: wipes the target dir and re-extracts on each run.
  system.userActivationScripts.libadwaitaWhitesur = {
    text = ''
      GRE="${gresource}"
      GR="${whitesur}/share/themes/${themeName}/gtk-4.0/gtk.gresource"
      DEST="$HOME/.config/gtk-4.0"
      rm -rf "$DEST/assets" "$DEST/windows-assets" "$DEST/gtk.css" "$DEST/gtk-dark.css" \
            "$DEST/gtk-Light.css" "$DEST/gtk-Dark.css"
      mkdir -p "$DEST/assets" "$DEST/windows-assets"
      "$GRE" extract "$GR" /org/gnome/theme/gtk.css       > "$DEST/gtk.css"
      "$GRE" extract "$GR" /org/gnome/theme/gtk-dark.css  > "$DEST/gtk-dark.css"
      "$GRE" list "$GR" | while IFS= read -r path; do
        case "$path" in
          /org/gnome/theme/gtk.css|/org/gnome/theme/gtk-dark.css) continue ;;
          /org/gnome/theme/assets/*)
            rel="''${path#/org/gnome/theme/}"
            mkdir -p "$DEST/$(dirname "$rel")"
            "$GRE" extract "$GR" "$path" > "$DEST/$rel"
            ;;
          *) : ;;
        esac
      done
    '';
  };
}
