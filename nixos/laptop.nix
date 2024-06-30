{ pkgs, ... }:
{
  # Configuration for managing suspension, hibernation, and laptop lid actions
  # Suspend after 10 minutes of inactivity and hibernate 30 minutes later
  services.logind = {
    lidSwitch = "suspend-then-hibernate"; # Action when laptop lid is closed
    lidSwitchDocked = "suspend-then-hibernate"; # Action when laptop lid is closed while docked
    lidSwitchExternalPower = "suspend-then-hibernate"; # Action when laptop lid is closed while on external power
    extraConfig = ''
      AllowSuspend=yes                              # Enable system suspension
      AllowHibernation=yes                          # Enable system hibernation
      AllowSuspendThenHibernate=yes                 # Enable suspend-then-hibernate action
      IdleAction=suspend-then-hibernate             # Action after the system is idle
      IdleActionSec=10min                           # Time before idle action is triggered (10 minutes)
      HibernateDelaySec=30min                       # Time delay before hibernating after suspension (30 minutes)
    '';
  };
  # Improve battery scaling the CPU governor and optimizing the general power
  services.auto-cpufreq.enable = true;

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    light.enable = true;
  };

  environment.systemPackages = with pkgs; [

    libinput
    libinput-gestures
  ];
}
