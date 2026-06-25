# ----------------------------------------------------------------------------
# Laptop Power Management Profile
#
# Configures power management, input devices, and essential utilities for laptops.
#
# Power Strategy:
# - Suspend is manual: `systemctl suspend` or `systemctl hibernate`.
# - Lid close / power key: logind triggers suspend directly.
# - No idle detection daemon (no swayidle, no autosuspend).
# - suspend-then-hibernate is disabled: NVIDIA's driver can't sequence the
#   nvidia-resume/nvidia-hibernate services between the S3→S4 transitions
#   in systemd's monolithic suspend-then-hibernate unit.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  services = {
    # systemd-logind: lid and power key behavior only.
    # Idle suspension is manual — no automatic daemon.
    # See: https://www.freedesktop.org/software/systemd/man/latest/logind.conf.html
    logind.settings.Login = {
      # Suspend on lid close regardless of power source.
      # WHY: suspend-then-hibernate is unreliable with NVIDIA's proprietary driver
      # (nvidia-resume/nvidia-hibernate services can't run between the S3→S4
      # transitions). Both systemctl suspend and systemctl hibernate work
      # individually, but the combined cycle doesn't. Plain suspend avoids this.
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "suspend";
      HandlePowerKey = "suspend";
      HandlePowerKeyLongPress = "poweroff";
      # Idle action disabled: suspend is manual.
      IdleAction = "ignore";
      # "no" = respect inhibitor locks on lid close. If the lid is closed while
      # an inhibitor is active, logind skips the action. When the inhibitor
      # releases, logind does NOT re-fire the event — suspend manually.
      LidSwitchIgnoreInhibited = "no";
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

    # Clight: Adaptive brightness and gamma (Night Light)
    # Uses ambient light sensor (ALS) or webcam fallback to adjust display.
    # Disabled: too invasive in practice; config kept for easy re-enable.
    clight = {
      enable = false;
      settings = {
        backlight.enabled = true;
        gamma.enabled = true;
        webcam.enabled = true; # Fallback if hardware ALS is missing
      };
    };

  };

  # Enable iio-sensor-proxy for hardware ambient light sensor support
  hardware.sensor.iio.enable = true;

  # systemd-sleep: enable basic sleep states.
  # suspend-then-hibernate is DISABLED — the HibernateDelaySec and
  # AllowSuspendThenHibernate options are intentionally omitted because NVIDIA's
  # driver can't sequence the nvidia-resume/nvidia-hibernate services between
  # the S3→S4 transitions in systemd's monolithic suspend-then-hibernate unit.
  # See: https://www.freedesktop.org/software/systemd/man/latest/sleep.conf.d.html
  systemd.sleep.settings.Sleep = {
    AllowSuspend = "yes";
    AllowHibernation = "yes";
  };

  environment.systemPackages = with pkgs; [
    brightnessctl # Screen brightness control
    libinput # Input device diagnostics/config
    libinput-gestures # Touchpad gesture support
  ];
}
