# ----------------------------------------------------------------------------
# Bluetooth Configuration
#
# Configures BlueZ Bluetooth stack with high-quality audio codec support.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false; # Disabled to save power; enable manually when needed
    settings.General = {
      # Enable experimental BlueZ features for better device support,
      # including battery level reporting for newer devices
      Experimental = true;
      KernelExperimental = true;

      # Prioritize connection speed over energy efficiency
      FastConnectable = true;

      # Allow devices to use multiple profiles simultaneously
      # (e.g., headset audio + keyboard input)
      MultiProfile = "multiple";

      # Auto-repair "Just Works" paired devices after disconnection
      # Improves convenience by avoiding manual re-pairing
      JustWorksRepairing = "always";
    };
  };

  # WirePlumber: Enable high-quality Bluetooth audio codecs (Modern JSON format)
  # WHY: WirePlumber 0.5+ removed Lua support. This SPA-JSON config ensures
  # high-bitrate audio and hardware volume control stay active.
  services.pipewire.wireplumber.extraConfig."51-bluez-config" = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.headset-roles" = [
        "hsp_hs"
        "hsp_ag"
        "hfp_hf"
        "hfp_ag"
      ];
    };
  };

  environment.systemPackages = with pkgs; [ bluez-tools ];
}
