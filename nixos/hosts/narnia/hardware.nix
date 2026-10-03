# ----------------------------------------------------------------------------
# Hardware Configuration for Narnia (Tongfang GK5CN6Z / Recoil II)
#
# Host-specific hardware tweaks, log fixes, and peripheral optimizations.
# ----------------------------------------------------------------------------
{ lib, pkgs, ... }:
{
  # ----------------------------------------------------------------------------
  # USB & Connectivity
  # ----------------------------------------------------------------------------
  services.udev.extraRules = ''
    # Disable problematic USB port 1-6
    # WHY: This internal port experiences persistent hardware-level enumeration
    # failures (error -71). The kernel's constant reset loops cause significant
    # I/O wait and system stutters. Disabling the port stops the reset cycle.
    ACTION=="add", SUBSYSTEM=="usb", KERNEL=="1-6", ATTR{authorized}="0"
  '';

  # ----------------------------------------------------------------------------
  # Graphics (Intel iGPU)
  # ----------------------------------------------------------------------------
  boot.kernelParams = [
    # Enable GuC/HuC firmware loading for Intel Gen 9 (Coffee Lake).
    # Mode 2 enables HuC (HEVC/H.264 microController):
    # - HuC handles firmware-based video authentication and enables hardware-
    #   accelerated decoding/encoding.
    # - Mode 3 (GuC + HuC) is disabled because GuC submission is often
    #   unstable on Coffee Lake (i7-8750H), causing log errors and freezes.
    "i915.enable_guc=2"
  ];

  # ----------------------------------------------------------------------------
  # Bluetooth (Intel Wireless-AC 9260)
  # ----------------------------------------------------------------------------
  hardware.bluetooth.settings.General = {
    # Disable kernel experimental features (including BAP / LE Audio)
    # WHY: This Intel adapter logs "Unable to find bap session" errors on
    # device detachment. KernelExperimental=false disables BAP at the kernel
    # level without using the invalid Disable=bap key that bluez 5.86 rejects.
    KernelExperimental = lib.mkForce false;
  };

  # ----------------------------------------------------------------------------
  # i8042 / Built-in Keyboard Resilience
  # ----------------------------------------------------------------------------
  # The GK5CN6Z EC is flaky around sleep transitions (see the i8042.nopnp /
  # i8042.reset kernel params in configuration.nix). Two symptoms are handled here:
  #
  # 1. The Fn key. This chassis reports Fn as an extended code (raw e078, translated
  #    set-2 0xf8) with no keycode mapping, and atkbd logs "Unknown key pressed" plus
  #    the setkeycodes hint for EVERY press/release pair — so a few Fn combos after a
  #    resume bury the journal. Note the sentinel values in atkbd.c: keycode 0 is
  #    ATKBD_KEY_UNKNOWN, which is exactly the state that triggers the log line, so
  #    mapping to 0 does NOT silence it. 255 is ATKBD_KEY_NULL, which the driver
  #    discards before any logging. Fn itself is not needed here — brightness/flight
  #    mode combos are handled by the WMI/EC device, not by the atkbd stream.
  systemd.services.i8042-fn-scancode = {
    description = "Ignore the Tongfang Fn extended scancode (e078)";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kbd}/bin/setkeycodes e078 255";
    };
  };

  # 2. A wedged key matrix after hibernate. The controller can come back answering
  #    the i8042 probe but not delivering real keys, which previously looked like a
  #    permanently dead keyboard. Unbinding and rebinding atkbd re-runs its
  #    initialisation sequence — the same reset the i8042.reset boot param performs —
  #    without requiring a reboot.
  #
  # systemd executes every executable in /etc/systemd/system-sleep/ with "pre"
  # before suspending and "post" after resuming. The hook runs asynchronously, so it
  # adds no latency to the resume path.
  #
  # atkbd is a serio driver, so the bind files live under /sys/bus/serio (the i8042
  # controller itself has no /sys/bus entry). Rebind recreates the input device and
  # resets the driver's scancode table, which is why the Fn mapping is re-applied
  # here. keyd needs no restart: it follows udev hotplug and re-grabs the new device.
  environment.etc."systemd/system-sleep/atkbd-resume.sh" = {
    mode = "0755";
    text = ''
      #!/bin/sh
      [ "$1" = "post" ] || exit 0

      echo serio0 > /sys/bus/serio/drivers/atkbd/unbind 2>/dev/null || true
      echo serio0 > /sys/bus/serio/drivers/atkbd/bind   2>/dev/null || true

      ${pkgs.kbd}/bin/setkeycodes e078 255 2>/dev/null || true
    '';
  };
}
