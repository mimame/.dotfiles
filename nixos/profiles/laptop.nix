{ pkgs, ... }:
{
  # Laptop Power Management Profile
  #
  # This module configures power management, input devices, and essential utilities for laptops.
  #
  # - Automatically suspends after 10 minutes of inactivity, then hibernates after 60 minutes in suspend.
  # - Handles lid, dock, and power key events for consistent suspend/hibernate behavior.
  # - Integrates with systemd-logind and systemd-sleep for robust power management.
  # - Touchpad settings are provided, but may be overridden by your tiling window manager (e.g., Sway/niri).
  # - Installs laptop-specific utilities for brightness and gesture control.

  # Power management: suspend after 10min idle, hibernate after 60min suspended
  services.logind = {
    # Actions for lid close, docked, and external power: always suspend-then-hibernate
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "suspend-then-hibernate";
    lidSwitchExternalPower = "suspend-then-hibernate";
    powerKey = "suspend-then-hibernate";
    powerKeyLongPress = "poweroff";
    # Extra logind config: suspend after 10min idle, then hibernate
    # See: https://www.freedesktop.org/software/systemd/man/latest/logind.conf.html#Options
    extraConfig = ''
      IdleAction=suspend-then-hibernate
      IdleActionSec=10min
    '';
  };

  # systemd-sleep: fine-tune suspend/hibernate permissions and timing
  # See: https://www.freedesktop.org/software/systemd/man/latest/sleep.conf.d.html#Options
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=yes
    SuspendMode=suspend-then-hibernate
    HibernateDelaySec=60min
  '';

  # Touchpad configuration (libinput)
  #
  # These settings may be overridden by the tiling window manager (e.g., Sway/niri).
  services.libinput = {
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

  # Essential laptop utilities
  environment.systemPackages = with pkgs; [
    brightnessctl # Control screen brightness from the terminal
    libinput # Diagnostics and configuration for input devices
    libinput-gestures # Touchpad gesture support (if used)
  ];
}
