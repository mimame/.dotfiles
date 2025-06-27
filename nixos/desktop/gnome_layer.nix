{ pkgs, ... }:
{

  # X11/Xorg and Display Manager Configuration
  # Even though we're running Wayland, services.xserver is still required because:
  #
  # 1. GDM (GNOME Display Manager) dependency:
  #    - GDM is built on top of X11 infrastructure even when it launches Wayland sessions
  #    - The display manager itself runs some X11 components for the login screen
  #    - GDM uses X11 for the greeter/login interface before starting the user session
  #
  # 2. Backward compatibility and fallback:
  #    - Provides X11 fallback session if Wayland fails or isn't supported
  #    - Some applications still require XWayland (X11 compatibility layer in Wayland)
  #    - Legacy applications that don't support Wayland natively need X11 libraries
  #
  # 3. NixOS architecture:
  #    - services.xserver enables essential graphics stack components beyond just X11
  #    - Configures graphics drivers, input devices, and display infrastructure
  #    - Sets up the foundation that both X11 and Wayland sessions depend on
  #
  # 4. XWayland requirement:
  #    - Most Wayland compositors (including GNOME Shell) run XWayland automatically
  #    - XWayland needs X11 server libraries and configuration to function
  #    - Applications like browsers, IDEs, and games often still use X11 protocols
  #
  # The actual Wayland session is launched by GDM after authentication, but the
  # underlying X11 infrastructure must be available for the complete desktop experience.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
  };

  # GNOME Keyring daemon - provides secure storage for passwords, keys, and certificates
  # This is the backend service that handles the actual storage and cryptographic operations
  # This is essential for:
  # - Automatically storing and retrieving passwords for applications
  # - Managing SSH keys and providing SSH agent functionality
  # - Storing WiFi passwords, email credentials, and other sensitive data
  # - Integration with web browsers for password management
  # - GPG key management and encryption operations
  # Without this, you'd need to manually enter passwords repeatedly and lose
  # the seamless password management that modern desktop environments provide
  services.gnome.gnome-keyring.enable = true;
  # Enable GNOME Keyring integration with PAM for GDM (GNOME Display Manager)
  # This automatically unlocks the user's keyring when they log in with their password,
  # providing seamless access to stored credentials without additional authentication prompts
  security.pam.services.gdm.enableGnomeKeyring = true;

  # GNOME Seahorse configuration for password and key management
  # Seahorse is the frontend/GUI application that provides a user interface
  # for interacting with the GNOME Keyring backend service
  # Both keyring (backend daemon) and seahorse (frontend GUI) are needed:
  # - Keyring handles the secure storage and cryptographic operations behind the scenes
  # - Seahorse provides the visual interface for users to manage their stored credentials
  programs = {
    # Enable Seahorse (GNOME's password and encryption key manager)
    # This provides a GUI for managing SSH keys, GPG keys, and passwords
    seahorse.enable = true;
  };
  # Configure SSH to use Seahorse's graphical password prompt
  # This integrates SSH key authentication with GNOME's keyring system
  programs.ssh.askPassword = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";

  # PolicyKit Authentication Agent - Essential for privilege escalation in GUI environments
  # PolicyKit (polkit) is a system-wide authorization framework that controls access to
  # privileged operations like mounting drives, installing software, or modifying system settings.
  #
  # Why polkit-gnome-authentication-agent is needed:
  # - GUI applications need a way to prompt for administrator credentials when performing privileged operations
  # - Without an authentication agent, GUI apps would fail silently or crash when trying to escalate privileges
  # - Console applications can use sudo/su, but GUI apps need a graphical authentication dialog
  # - Examples: mounting USB drives in file managers, updating system via GUI package managers,
  #   changing network settings, installing fonts, modifying system time
  #
  # Relationship with keyring/seahorse:
  # - polkit handles AUTHORIZATION (can this user perform this action?)
  # - keyring handles AUTHENTICATION (store/retrieve passwords and credentials)
  # - They work together: polkit may request admin password via the auth agent,
  #   while keyring stores the credentials for future use
  # - Seahorse provides GUI for keyring management, polkit-gnome provides GUI for privilege prompts
  #
  # Why as systemd user service:
  # - Must run in user session (not system-wide) to display GUI dialogs to the correct user
  # - Needs to start automatically when graphical session begins
  # - Should restart on failure to ensure privilege escalation always works
  # - User services run with proper environment variables and D-Bus session access
  # - Systemd ensures proper dependency ordering and lifecycle management
  systemd = {
    user.services = {
      polkit-gnome-authentication-agent-1 = {
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
    };
  };

  # GNOME Settings Daemon - Core GNOME desktop environment service
  # This daemon manages essential desktop functionality including:
  # - Keyboard shortcuts and key bindings
  # - Display settings (brightness, resolution, multi-monitor setup)
  # - Audio/volume control and sound themes
  # - Mouse and touchpad configuration
  # - Power management (suspend, hibernate, battery monitoring)
  # - Automatic time zone detection and updates
  # - Accessibility features and assistive technologies
  # - Notification handling and display
  # - Background/wallpaper management
  # Without this service, many core desktop features would not function properly
  services.gnome.gnome-settings-daemon.enable = true;

  # GNOME Online Accounts - Centralized account management service
  # This service provides unified authentication and integration for online services:
  # - Email accounts (Gmail, Outlook, IMAP/POP3) for Evolution/Geary
  # - Calendar and contacts synchronization (Google, Exchange, CalDAV/CardDAV)
  # - Cloud storage integration (Google Drive, OneDrive, Nextcloud)
  # - Social media accounts for Photos and other applications
  # - Enterprise authentication (Kerberos, Active Directory)
  # Benefits:
  # - Single sign-on: authenticate once, access multiple services
  # - Automatic credential management across GNOME applications
  # - Seamless synchronization of data between local and cloud services
  # - Centralized account settings in GNOME Control Center
  services.gnome.gnome-online-accounts.enable = true;

  # GVFS (GNOME Virtual File System) - Virtual filesystem layer for desktop integration
  # This service provides seamless access to various storage backends and network protocols:
  #
  # Local features:
  # - Trash functionality (move files to trash instead of permanent deletion)
  # - Automatic mounting and unmounting of removable media (USB drives, CDs)
  # - Archive browsing (browse ZIP/TAR files as folders without extracting)
  # - Metadata handling for file properties and thumbnails
  #
  # Network protocols supported:
  # - SFTP/SSH: secure file transfer over SSH connections
  # - SMB/CIFS: Windows file sharing (access network drives, printers)
  # - FTP/FTPS: traditional file transfer protocol
  # - HTTP/HTTPS: browse web servers as file systems
  # - WebDAV: web-based file sharing (Nextcloud, SharePoint)
  # - AFP: Apple Filing Protocol for macOS file sharing
  # - MTP: Media Transfer Protocol for Android devices and cameras
  #
  # Integration benefits:
  # - All protocols appear as regular folders in file managers (Nautilus)
  # - Applications can save/open files from network locations transparently
  # - Bookmarks and favorites for frequently accessed network locations
  # - Automatic credential caching for seamless reconnection
  services.gvfs.enable = true;

  # DConf - GNOME configuration system backend
  # DConf is the low-level configuration storage system used by GNOME and GTK applications:
  #
  # What it does:
  # - Stores user preferences and application settings in a binary database
  # - Provides a unified configuration API for GNOME applications
  # - Handles schema validation and type checking for configuration values
  # - Supports configuration lockdown and system-wide defaults
  # - Enables real-time configuration changes without application restart
  #
  # Why it's essential:
  # - Prevents "dconf-WARNING" errors that appear when GNOME apps can't access settings
  # - Required for GNOME Control Center and application preferences to function
  # - Enables gsettings command-line tool for configuration management
  # - Necessary for proper theme application and desktop customization
  # - Allows applications to remember user preferences between sessions
  #
  # Without dconf, GNOME applications would:
  # - Display warning messages about missing configuration backend
  # - Fail to save or load user preferences
  # - Unable to apply themes or customizations properly
  # - Lose settings between application restarts
  programs.dconf.enable = true;

  environment.systemPackages =
    with pkgs;
    [
    ]
    ++ (with pkgs.unstable; [

      (hiPrio beauty-line-icon-theme) # avoid default gnome icon themes
      baobab
      eog
      file-roller
      glib # gsettings
      gnome-control-center
      gparted
      loupe
      meld
      gthumb
      evince
      nautilus
      sweet
    ]);
}
