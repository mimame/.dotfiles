# ----------------------------------------------------------------------------
# Laptop Power Management Profile
#
# Configures power management, input devices, and essential utilities for laptops.
#
# Power Strategy:
# - Suspend after 10min idle → Hibernate after 2h in suspend
# - Lid close behavior optimized for battery/plugged-in scenarios
# - Touchpad settings (may be overridden by compositor like Niri/Sway)
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  services = {
    # Power management with systemd-logind
    # See: https://www.freedesktop.org/software/systemd/man/latest/logind.conf.html#Options
    logind.settings.Login = {
      # Lid behavior: suspend-then-hibernate on battery for maximum battery life
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchDocked = "ignore"; # Faster suspend when docked
      HandleLidSwitchExternalPower = "suspend"; # Faster suspend when plugged in
      HandlePowerKey = "suspend";
      HandlePowerKeyLongPress = "poweroff";
      # Disable logind's idle timer; let DE handle it
      IdleAction = "ignore";
      LidSwitchIgnoreInhibited = "yes";
    };

    # Touchpad configuration (may be overridden by compositor)
    # See: https://wayland.freedesktop.org/libinput/doc/latest/clickpad-softbuttons.html
    libinput = {
      enable = true;
      touchpad = {
        clickMethod = "clickfinger"; # Two-finger right-click, three-finger middle-click
        disableWhileTyping = true;
        middleEmulation = false;
        naturalScrolling = true;
        tappingButtonMap = "lrm"; # One-finger left, two-finger right, three-finger middle
        tapping = true;
      };
    };

    # Fingerprint authentication support (for DMS Shell)
    fprintd.enable = true;
  };

  # systemd-sleep: Hibernate after 2h in suspend
  # See: https://www.freedesktop.org/software/systemd/man/latest/sleep.conf.d.html
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=yes
    HibernateDelaySec=2h
  '';

  environment.systemPackages = with pkgs; [
    brightnessctl # Screen brightness control
    libinput # Input device diagnostics/config
    libinput-gestures # Touchpad gesture support
  ];
}
