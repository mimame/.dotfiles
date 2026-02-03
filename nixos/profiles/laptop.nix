{ pkgs, ... }:
{
  # Laptop Power Management Profile
  #
  # This module configures power management, input devices, and essential utilities for laptops.
  #
  # - Automatically suspends after 10 minutes of inactivity, then hibernates after 120 minutes in suspend.
  # - Handles lid, dock, and power key events for consistent suspend/hibernate behavior.
  # - Integrates with systemd-logind and systemd-sleep for robust power management.
  # - Touchpad settings are provided, but may be overridden by your tiling window manager (e.g., Sway/niri).
  # - Installs laptop-specific utilities for brightness and gesture control.

  services = {
    # Power management: suspend after 10min idle, hibernate after 120min suspended
    logind = {
      # See: https://www.freedesktop.org/software/systemd/man/latest/logind.conf.html#Options
      settings = {
        Login = {
          # Suspend then hibernate on lid close, power key press, or after 10 minutes of inactivity.
          HandleLidSwitch = "suspend-then-hibernate";
          HandleLidSwitchDocked = "suspend-then-hibernate";
          HandleLidSwitchExternalPower = "suspend-then-hibernate";
          HandlePowerKey = "suspend-then-hibernate";
          HandlePowerKeyLongPress = "poweroff";
          IdleAction = "suspend-then-hibernate";
          IdleActionSec = "10min";
        };
      };
    };

    # Touchpad configuration (libinput)
    #
    # These settings may be overridden by the tiling window manager (e.g., Sway/niri).
    libinput = {
      enable = true;
      touchpad = {
        # See: https://wayland.freedesktop.org/libinput/doc/latest/clickpad-softbuttons.html#clickpad-softbuttons
        clickMethod = "buttonareas";
        disableWhileTyping = true;
        middleEmulation = false;
        naturalScrolling = true;
        tappingButtonMap = "lrm";
        tapping = true;
      };
    };

    # Enable fprintd for fingerprint authentication support.
    # Requested by DMS Shell for fingerprint features.
    fprintd.enable = true;
  };

  # systemd-sleep: fine-tune suspend/hibernate permissions and timing
  # See: https://www.freedesktop.org/software/systemd/man/latest/sleep.conf.d.html#Options
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=yes
    SuspendMode=suspend-then-hibernate
    HibernateDelaySec=120min
  '';

  environment.systemPackages = with pkgs; [
    brightnessctl # Control screen brightness from the terminal
    libinput # Diagnostics and configuration for input devices
    libinput-gestures # Touchpad gesture support (if used)
  ];
}
