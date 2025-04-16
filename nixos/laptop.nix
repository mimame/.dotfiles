{ pkgs, ... }:
{
  # Configuration for managing suspension, hibernation, and laptop lid actions
  # Suspend after 10 minutes of inactivity and hibernate 30 minutes later
  services.logind = {
    lidSwitch = "suspend-then-hibernate"; # Action when laptop lid is closed
    lidSwitchDocked = "suspend-then-hibernate"; # Action when laptop lid is closed while docked
    lidSwitchExternalPower = "suspend-then-hibernate"; # Action when laptop lid is closed while on external power
    powerKey = "suspend-then-hibernate";
    powerKeyLongPress = "poweroff";
    # https://www.freedesktop.org/software/systemd/man/latest/logind.conf.html#Options
    extraConfig = ''
      IdleAction=suspend-then-hibernate
      IdleActionSec=60min
    '';
  };
  # https://www.freedesktop.org/software/systemd/man/latest/sleep.conf.d.html#Options
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=yes
    SuspendMode=suspend-then-hibernate
    HibernateDelaySec=60min
  '';

  # Enable touchpad support (enabled by default in most desktopManager).
  services.libinput = {
    enable = true;
    # Ignored here! Implemented by Sway
    touchpad = {
      # https://wayland.freedesktop.org/libinput/doc/latest/clickpad-softbuttons.html#clickpad-softbuttons
      clickMethod = "buttonareas";
      disableWhileTyping = true;
      middleEmulation = false;
      naturalScrolling = true;
      tappingButtonMap = "lrm";
      tapping = true;
    };
  };

  environment.systemPackages = with pkgs; [

    brightnessctl
    libinput
    libinput-gestures
  ];
}
