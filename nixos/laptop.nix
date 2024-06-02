{ pkgs, ... }:
{
  # Configuration for suspension, hibernation and the laptop lid
  # Suspend in 10 minutes of inactivity and hibernate half hour later
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "suspend-then-hibernate";
    lidSwitchExternalPower = "suspend-then-hibernate";
    extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=yes
      AllowSuspendThenHibernate=yes
      SuspendMode=suspend-then-hibernate
      SuspendState=suspend-then-hibernate
      IdleActionSec=10min
      IdleAction=suspend-then-hibernate
      HibernateDelaySec=30min
    '';
  };
  # Improve battery scaling the CPU governor and optimizing the general power
  services.auto-cpufreq.enable = true;

  # Enable touchpad support (enabled by default in most desktopManager).
  services.xserver.libinput = {
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
